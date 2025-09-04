*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem
Library           BuiltIn
Library           Process
Library           String

*** Variables ***
${BROWSER}        chrome
${URL}            https://rest-fin-fe.mangoforest-55e2394a.centralindia.azurecontainerapps.io/
${Timeout}        20s
${email_id}       test@r1.com
${password}       Naresh

*** Test Cases ***
Login to the platform as fiancier
    ${unique_dir}=    Generate Random String    8    [LETTERS]
    ${chrome_options}=    Create List    --headless    --disable-gpu    --no-sandbox    --disable-dev-shm-usage    --user-data-dir=/tmp/chrome-${unique_dir}
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//input[@placeholder="Enter your email"]    ${Timeout}
    Input Text    xpath=//input[@placeholder="Enter your email"]    ${email_id}
    Input Text    xpath=//input[@placeholder="Enter your password"]    ${password}
    Click Element    xpath=//button[text()="Login"]
    Sleep   10s
    Close Browser
