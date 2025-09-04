*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem
Library           BuiltIn
Library           Process
Library           String

*** Variables ***
${BROWSER}      chrome
${CHROME_OPTIONS}   --headless --disable-gpu --no-sandbox --disable-dev-shm-usage --user-data-dir=/tmp/chrome-${RANDOM}
${URL}            https://rest-fin-fe.mangoforest-55e2394a.centralindia.azurecontainerapps.io/
${Timeout}        20s
${email_id}       test@r1.com
${password}       Naresh

*** Test Cases ***
Login to the platform as fiancier

    [Documentation]    This test case logs into the fiancier platform using provided credentials.
    [Tags]    login    fiancier

    # Open and Maximize Browser
    Open Browser    ${URL}    ${BROWSER}    options=add_argument("${CHROME_OPTIONS}")
    Maximize Browser Window

    # Entering Email and Password
    Wait Until Element Is Visible    xpath=//input[@placeholder="Enter your email"]    ${Timeout}
    Input Text    xpath=//input[@placeholder="Enter your email"]    ${email_id}
    Input Text    xpath=//input[@placeholder="Enter your password"]    ${password}
    Click Element    xpath=//button[text()="Login"]

    Sleep   1800s
    Close Browser