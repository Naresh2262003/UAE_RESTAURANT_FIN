*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    BuiltIn
Library    String

*** Variables ***
${BROWSER}        chrome
${URL}            https://rest-fin-fe.mangoforest-55e2394a.centralindia.azurecontainerapps.io/
${Timeout}        20s
${email_id}       test@r1.com
${password}       Naresh

*** Test Cases ***
Login to the platform as fiancier
    # Create Chrome Options
    ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome options}    add_argument    --headless
    Call Method    ${chrome options}    add_argument    --disable-gpu
    Call Method    ${chrome options}    add_argument    --no-sandbox
    Call Method    ${chrome options}    add_argument    --disable-dev-shm-usage

    # Open Browser using the correct 'options' argument
    Open Browser    ${URL}    chrome    options=${chrome options}
    Maximize Browser Window

    Wait Until Element Is Visible    xpath=//input[@placeholder="Enter your email"]    ${Timeout}
    Input Text    xpath=//input[@placeholder="Enter your email"]    ${email_id}
    Input Text    xpath=//input[@placeholder="Enter your password"]    ${password}
    Click Element    xpath=//button[text()="Login"]
    Sleep   10s
    Close Browser
