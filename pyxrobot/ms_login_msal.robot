*** Settings ***
Library    msal_keyword.py
Library    OperatingSystem
Library    Collections

*** Variables ***
# ---- Azure AD ----
${TENANT_ID}          a21a4422-036f-4a04-a71b-895636977953
${MS_CLIENT_ID}       b41b6acd-3f8f-4ccd-a6ff-5daf64cdf44e
${REDIRECT_URI}       https://login.live.com/oauth20_desktop.srf

# ---- MS Scopes ----
@{SCOPES}
...    User.Read.All
...    openid
...    profile
...    Group.Read.All
...    offline_access

# ---- Credentials (override ด้วย -v EMAIL_TEST:xxx -v PASSWORD_TEST:xxx) ----
${EMAIL_TEST}         00552@UATTMB.tmbbank.com
${PASSWORD_TEST}      Tmb@12345

# ---- Tablet Auth Service ----
${TOKEN_ENDPOINT}     https://cmtop-sit1.tau2904.com/v1/tablet-auth-service/oauth2/token
${TAB_CLIENT_ID}      af7e1380-d22e-42a1-80b4-32a36a82935d
${TAB_CLIENT_SECRET}  W5^L<nUn#XBwMUQfyVj^5Jmp6Mkph7C280!Q4hb6VZBkl>pG99@qPcVZ3EHXiWWI
${TAB_SCOPE}          Staff.Tablet

# ---- Output ----
${OUTPUT_TOKEN_FILE}  ${CURDIR}/../../js_result/token_tablet.json


*** Test Cases ***

# -----------------------------------------------------------------------
# Option A: One-shot — ทำทุกอย่างใน keyword เดียว (แนะนำ)
# -----------------------------------------------------------------------
Login And Get Token Via MSAL One Shot
    [Documentation]    Login MS + exchange token + save file ในขั้นตอนเดียว

    ${access_token}=    Login And Get Tablet Token
    ...    tenant_id=${TENANT_ID}
    ...    ms_client_id=${MS_CLIENT_ID}
    ...    username=${EMAIL_TEST}
    ...    password=${PASSWORD_TEST}
    ...    scopes=${SCOPES}
    ...    token_endpoint=${TOKEN_ENDPOINT}
    ...    tab_client_id=${TAB_CLIENT_ID}
    ...    tab_client_secret=${TAB_CLIENT_SECRET}
    ...    redirect_uri=${REDIRECT_URI}
    ...    scope=${TAB_SCOPE}
    ...    output_path=${OUTPUT_TOKEN_FILE}

    Log    Access Token = ${access_token}
    Should Not Be Empty    ${access_token}


# -----------------------------------------------------------------------
# Option B: Step-by-step — แยก keyword ทีละขั้นตอน (debug ง่าย)
# -----------------------------------------------------------------------
Login And Get Token Via MSAL Step By Step
    [Documentation]    แยก step ให้เห็น flow ชัดเจน เหมาะสำหรับ debug

    # Step 1: Login MS via MSAL → ได้ MS access_token
    ${ms_token}=    Get Azure AD Code Via MSAL
    ...    tenant_id=${TENANT_ID}
    ...    client_id=${MS_CLIENT_ID}
    ...    username=${EMAIL_TEST}
    ...    password=${PASSWORD_TEST}
    ...    scopes=${SCOPES}
    ...    redirect_uri=${REDIRECT_URI}

    Log    MS Token = ${ms_token}
    Should Not Be Empty    ${ms_token}

    # Step 2: แลก MS token → tablet access_token
    ${token_data}=    Exchange Token With Tablet Auth Service
    ...    ms_access_token=${ms_token}
    ...    token_endpoint=${TOKEN_ENDPOINT}
    ...    client_id=${TAB_CLIENT_ID}
    ...    client_secret=${TAB_CLIENT_SECRET}
    ...    redirect_uri=${REDIRECT_URI}
    ...    scope=${TAB_SCOPE}

    ${access_token}=    Get From Dictionary    ${token_data}    access_token
    Log    Tablet Access Token = ${access_token}
    Should Not Be Empty    ${access_token}

    # Step 3: Save token ลงไฟล์
    Save Token To File    ${token_data}    ${OUTPUT_TOKEN_FILE}

    # Step 4: ยืนยันว่าไฟล์ถูกสร้าง
    File Should Exist    ${OUTPUT_TOKEN_FILE}
    Log    Token saved to ${OUTPUT_TOKEN_FILE}
