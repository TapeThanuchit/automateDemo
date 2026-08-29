"""
msal_keyword.py
---------------
Custom Robot Framework keyword library for Microsoft Authentication (MSAL).
ใช้ MSAL (Microsoft Authentication Library) เพื่อ login โดยไม่ต้องเปิดเบราว์เซอร์

Install:
    pip install msal requests

Usage in Robot Framework:
    Library    msal_keyword.py
"""

import msal
import requests
import json
import uuid
import os
from robot.api.deco import keyword
from robot.api import logger


class msal_keyword:

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self):
        self._msal_app = None
        self._token_cache = msal.SerializableTokenCache()

    # ------------------------------------------------------------------
    # 1. Get Azure AD authorization code via MSAL (Resource Owner Password)
    # ------------------------------------------------------------------
    @keyword("Get Azure AD Code Via MSAL")
    def get_azure_ad_code_via_msal(
        self,
        tenant_id: str,
        client_id: str,
        username: str,
        password: str,
        scopes: list,
        redirect_uri: str,
    ) -> str:
        """
        Login ด้วย username/password ผ่าน MSAL แล้วดึง authorization code กลับมา
        เทียบเท่ากับการกรอก form บนเว็บแต่ทำแบบ programmatic

        Args:
            tenant_id    : Azure AD tenant ID
            client_id    : Azure App client_id
            username     : email ที่ใช้ login
            password     : password
            scopes       : list of scopes เช่น ['User.Read.All', 'openid']
            redirect_uri : redirect URI ที่ลงทะเบียนไว้ใน Azure

        Returns:
            authorization_code (str)
        """
        authority = f"https://login.microsoftonline.com/{tenant_id}"

        app = msal.PublicClientApplication(
            client_id=client_id,
            authority=authority,
            token_cache=self._token_cache,
        )

        logger.info(f"[MSAL] Attempting login for user: {username}")

        result = app.acquire_token_by_username_password(
            username=username,
            password=password,
            scopes=scopes,
        )

        if "error" in result:
            error_msg = result.get("error_description", result.get("error"))
            raise AssertionError(f"[MSAL] Login failed: {error_msg}")

        # เก็บ access_token และ account ไว้ใช้ต่อ
        self._msal_app = app
        self._account = app.get_accounts(username=username)[0]

        access_token = result.get("access_token")
        logger.info("[MSAL] Login successful — access_token acquired")

        return access_token

    # ------------------------------------------------------------------
    # 2. Exchange token กับ tablet-auth-service
    # ------------------------------------------------------------------
    @keyword("Exchange Token With Tablet Auth Service")
    def exchange_token_with_tablet_auth_service(
        self,
        ms_access_token: str,
        token_endpoint: str,
        client_id: str,
        client_secret: str,
        redirect_uri: str,
        scope: str,
        device_id: str = "4STBIGSOVT4MTB7F2LA665TF",
        device_model: str = "A2379",
        device_nickname: str = "Developer-P9",
    ) -> dict:
        """
        ส่ง MS access_token ไปแลกกับ token จาก tablet-auth-service
        เทียบเท่ากับฟังก์ชัน sendData() ใน JS เดิม

        Returns:
            dict ที่มี access_token, refresh_token ฯลฯ
        """
        correlation_id = str(uuid.uuid4())

        headers = {
            "accept": "*",
            "accept-language": "TH",
            "channel": "TEP-TABLET",
            "x-correlation-id": correlation_id,
            "app-version": "1.0.0",
            "device-id": device_id,
            "device-model": device_model,
            "device-nickname": device_nickname,
            "device-os": "0",
            "content-type": "application/x-www-form-urlencoded",
            "automate": "true",
        }

        body = {
            "code": ms_access_token,
            "client_id": client_id,
            "client_secret": client_secret,
            "grant_type": "ad_authorization_code",
            "redirect_uri": redirect_uri,
            "scope": scope,
        }

        logger.info(f"[MSAL] Exchanging token at: {token_endpoint}")

        response = requests.post(
            url=token_endpoint,
            data=body,
            headers=headers,
            verify=False,  # ignoreHTTPSErrors=true
        )

        if response.status_code != 200:
            raise AssertionError(
                f"[MSAL] Token exchange failed: {response.status_code} — {response.text}"
            )

        result = response.json()
        access_token = result["data"]["access_token"]

        logger.info(f"[MSAL] Token exchange successful")
        return result["data"]

    # ------------------------------------------------------------------
    # 3. Save token to JSON file
    # ------------------------------------------------------------------
    @keyword("Save Token To File")
    def save_token_to_file(self, token_data: dict, output_path: str) -> None:
        """
        บันทึก token ลงไฟล์ JSON
        เทียบเท่า fs.writeFileSync() ใน JS เดิม
        """
        os.makedirs(os.path.dirname(output_path), exist_ok=True)

        payload = {"access_token": token_data.get("access_token")}

        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(payload, f, indent=2)

        logger.info(f"[MSAL] Token saved to: {output_path}")

    # ------------------------------------------------------------------
    # 4. One-shot keyword (ทำทุกอย่างในขั้นตอนเดียว)
    # ------------------------------------------------------------------
    @keyword("Login And Get Tablet Token")
    def login_and_get_tablet_token(
        self,
        tenant_id: str,
        ms_client_id: str,
        username: str,
        password: str,
        scopes: list,
        token_endpoint: str,
        tab_client_id: str,
        tab_client_secret: str,
        redirect_uri: str,
        scope: str,
        output_path: str = None,
    ) -> str:
        """
        One-shot keyword: login MS → exchange token → (optional) save to file
        คืนค่า access_token กลับไปให้ Robot test ใช้ต่อได้ทันที
        """
        # Step 1: Login MS via MSAL
        ms_token = self.get_azure_ad_code_via_msal(
            tenant_id=tenant_id,
            client_id=ms_client_id,
            username=username,
            password=password,
            scopes=scopes,
            redirect_uri=redirect_uri,
        )

        # Step 2: Exchange กับ tablet-auth-service
        token_data = self.exchange_token_with_tablet_auth_service(
            ms_access_token=ms_token,
            token_endpoint=token_endpoint,
            client_id=tab_client_id,
            client_secret=tab_client_secret,
            redirect_uri=redirect_uri,
            scope=scope,
        )

        # Step 3: Save (optional)
        if output_path:
            self.save_token_to_file(token_data, output_path)

        return token_data.get("access_token")
