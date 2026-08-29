*** Settings ***
# โหลด config จาก config.yaml อัตโนมัติ (อยู่ folder เดียวกับ library)
# หรือระบุ path ตรงๆ: Library    msal_keyword.py    config_path=/path/to/config.yaml
Library    msal_keyword.py


*** Test Cases ***

# -----------------------------------------------------------------------
# Option A: One-shot — ดึง config จาก YAML/ENV ทั้งหมด (แนะนำ)
# -----------------------------------------------------------------------
Get Tablet Token From Config
    [Documentation]
    ...    ดึง config ทั้งหมดจาก config.yaml หรือ ENV variable (.zshrc)
    ...    ไม่ต้อง hardcode อะไรใน test file เลย

    ${access_token}=    Get Tablet Access Token
    Log    Access Token = ${access_token}
    Should Not Be Empty    ${access_token}


# -----------------------------------------------------------------------
# Option B: Override credential ตอนรัน (เช่น user อื่น)
# -----------------------------------------------------------------------
Get Tablet Token With Different User
    [Documentation]
    ...    ใช้ config จาก YAML/ENV แต่ override username/password ได้
    ...    เหมาะสำหรับรันหลาย user โดยไม่ต้องแก้ yaml

    ${access_token}=    Get Tablet Access Token
    ...    username=other_user@UATTMB.tmbbank.com
    ...    password=OtherPass@123
    Log    Access Token = ${access_token}
    Should Not Be Empty    ${access_token}


# -----------------------------------------------------------------------
# Option C: Step-by-step (debug ง่าย)
# -----------------------------------------------------------------------
Get Tablet Token Step By Step
    [Documentation]    แยก step ให้เห็น flow ทีละขั้น

    # Step 1: Login MS → ได้ MS token (ดึง config จาก YAML/ENV เอง)
    ${ms_token}=    Get MS Access Token Via MSAL
    Log    MS Token = ${ms_token}
    Should Not Be Empty    ${ms_token}

    # Step 2: แลก → ได้ tablet token
    ${access_token}=    Exchange MS Token For Tablet Token
    ...    ms_access_token=${ms_token}
    Log    Tablet Token = ${access_token}
    Should Not Be Empty    ${access_token}
