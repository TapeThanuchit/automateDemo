"""
msal_keyword.py
---------------
Custom Robot Framework keyword library for Microsoft Authentication (MSAL).

Install:
    pip install msal requests pyyaml

Config priority (สูง → ต่ำ):
    1. Environment variable (.zshrc)  ← อนาคต
    2. YAML file                      ← ปัจจุบัน
    3. ค่า default / argument ที่ส่งมาตรงๆ
"""

import msal
import requests
import uuid
import os
import yaml
from robot.api.deco import keyword
from robot.api import logger


class msal_keyword:

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self, config_path: str = None):
        """
        Args:
            config_path: path ของ config.yaml (optional)
                         ถ้าไม่ระบุจะหา config.yaml ใน folder เดียวกับ library
        """
        self._token_cache = msal.SerializableTokenCache()
        self._config = self._load_config(config_path)

    # ------------------------------------------------------------------
    # Config loader — รองรับ YAML และ ENV variable
    # ------------------------------------------------------------------
    def _load_config(self, config_path: str = None) -> dict:
        """
        โหลด config จาก YAML ก่อน แล้ว override ด้วย ENV variable
        ถ้ามี ENV variable ตั้งไว้ใน .zshrc จะใช้ค่านั้นแทน YAML เสมอ
        """
        config = {}

        # --- 1. โหลดจาก YAML ---
        yaml_path = config_path or os.path.join(os.path.dirname(__file__), "config.yaml")
        if os.path.exists(yaml_path):
            with open(yaml_path, "r", encoding="utf-8") as f:
                config = yaml.safe_load(f) or {}
            logger.info(f"[MSAL] Loaded config from: {yaml_path}")
        else:
            logger.warn(f"[MSAL] config.yaml not found at: {yaml_path}")

        # --- 2. Override ด้วย ENV variable (.zshrc) ถ้ามี ---
        # วิธีตั้งใน .zshrc:
        #   export AZURE_TENANT_ID="xxx"
        #   export AZURE_MS_CLIENT_ID="xxx"
        #   export AZURE_REDIRECT_URI="xxx"
        #   export MSAL_USERNAME="xxx"
        #   export MSAL_PASSWORD="xxx"
        #   export TAB_TOKEN_ENDPOINT="xxx"
        #   export TAB_CLIENT_ID="xxx"
        #   export TAB_CLIENT_SECRET="xxx"
        #   export TAB_SCOPE="xxx"

        env_overrides = {
            "azure.tenant_id":          os.environ.get("AZURE_TENANT_ID"),
            "azure.ms_client_id":       os.environ.get("AZURE_MS_CLIENT_ID"),
            "azure.redirect_uri":       os.environ.get("AZURE_REDIRECT_URI"),
            "credentials.username":     os.environ.get("MSAL_USERNAME"),
            "credentials.password":     os.environ.get("MSAL_PASSWORD"),
            "tablet_auth.token_endpoint": os.environ.get("TAB_TOKEN_ENDPOINT"),
            "tablet_auth.client_id":    os.environ.get("TAB_CLIENT_ID"),
            "tablet_auth.client_secret": os.environ.get("TAB_CLIENT_SECRET"),
            "tablet_auth.scope":        os.environ.get("TAB_SCOPE"),
        }

        for key_path, env_val in env_overrides.items():
            if env_val:
                section, key = key_path.split(".")
                if section not in config:
                    config[section] = {}
                config[section][key] = env_val
                logger.info(f"[MSAL] Override from ENV: {key_path}")

        return config

    def _get(self, section: str, key: str, fallback=None):
        """ดึงค่าจาก config dict"""
        return self._config.get(section, {}).get(key, fallback)

    # ------------------------------------------------------------------
    # 1. Login MS → return MS access_token
    # ------------------------------------------------------------------
    @keyword("Get MS Access Token Via MSAL")
    def get_ms_access_token_via_msal(
        self,
        username: str = None,
        password: str = None,
        tenant_id: str = None,
        client_id: str = None,
        scopes: list = None,
    ) -> str:
        """
        Login MS ด้วย username/password ผ่าน MSAL
        ถ้าไม่ส่ง argument มา จะดึงจาก config.yaml หรือ ENV variable อัตโนมัติ
        Returns: MS access_token (str)
        """
        _tenant_id   = tenant_id  or self._get("azure", "tenant_id")
        _client_id   = client_id  or self._get("azure", "ms_client_id")
        _username    = username   or self._get("credentials", "username")
        _password    = password   or self._get("credentials", "password")
        _scopes      = scopes     or self._get("azure", "scopes", [])

        authority = f"https://login.microsoftonline.com/{_tenant_id}"

        app = msal.PublicClientApplication(
            client_id=_client_id,
            authority=authority,
            token_cache=self._token_cache,
        )

        logger.info(f"[MSAL] Logging in as: {_username}")

        result = app.acquire_token_by_username_password(
            username=_username,
            password=_password,
            scopes=_scopes,
        )

        if "error" in result:
            error_msg = result.get("error_description", result.get("error"))
            raise AssertionError(f"[MSAL] Login failed: {error_msg}")

        logger.info("[MSAL] MS login successful")
        return result.get("access_token")

    # ------------------------------------------------------------------
    # 2. Exchange MS token → return tablet access_token
    # ------------------------------------------------------------------
    @keyword("Exchange MS Token For Tablet Token")
    def exchange_ms_token_for_tablet_token(
        self,
        ms_access_token: str,
        token_endpoint: str = None,
        client_id: str = None,
        client_secret: str = None,
        redirect_uri: str = None,
        scope: str = None,
        device_id: str = "4STBIGSOVT4MTB7F2LA665TF",
        device_model: str = "A2379",
        device_nickname: str = "Developer-P9",
    ) -> str:
        """
        แลก MS access_token → tablet access_token ผ่าน tablet-auth-service
        ถ้าไม่ส่ง argument มา จะดึงจาก config.yaml หรือ ENV variable อัตโนมัติ
        Returns: tablet access_token (str)
        """
        _endpoint     = token_endpoint or self._get("tablet_auth", "token_endpoint")
        _client_id    = client_id      or self._get("tablet_auth", "client_id")
        _client_secret= client_secret  or self._get("tablet_auth", "client_secret")
        _redirect_uri = redirect_uri   or self._get("azure", "redirect_uri")
        _scope        = scope          or self._get("tablet_auth", "scope")

        headers = {
            "accept": "*",
            "accept-language": "TH",
            "channel": "TEP-TABLET",
            "x-correlation-id": str(uuid.uuid4()),
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
            "client_id": _client_id,
            "client_secret": _client_secret,
            "grant_type": "ad_authorization_code",
            "redirect_uri": _redirect_uri,
            "scope": _scope,
        }

        logger.info(f"[MSAL] Exchanging token at: {_endpoint}")

        response = requests.post(url=_endpoint, data=body, headers=headers, verify=False)

        if response.status_code != 200:
            raise AssertionError(
                f"[MSAL] Token exchange failed: {response.status_code} — {response.text}"
            )

        tablet_token = response.json()["data"]["access_token"]
        logger.info("[MSAL] Token exchange successful")
        return tablet_token

    # ------------------------------------------------------------------
    # 3. One-shot: login + exchange → return tablet token ทันที
    # ------------------------------------------------------------------
    @keyword("Get Tablet Access Token")
    def get_tablet_access_token(
        self,
        username: str = None,
        password: str = None,
    ) -> str:
        """
        One-shot keyword — ดึง config จาก YAML/ENV อัตโนมัติ
        override username/password ได้ถ้าต้องการ
        Returns: tablet access_token (str)
        """
        ms_token = self.get_ms_access_token_via_msal(
            username=username,
            password=password,
        )

        tablet_token = self.exchange_ms_token_for_tablet_token(
            ms_access_token=ms_token,
        )

        return tablet_token
