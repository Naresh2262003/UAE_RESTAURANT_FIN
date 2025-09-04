*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem
Library           BuiltIn
Library           Process
Library           String
Library           JSONLibrary
Library           Collections

*** Variables ***
${BROWSER}        chrome
${URL}            https://rest-fin-fe.mangoforest-55e2394a.centralindia.azurecontainerapps.io/
${Timeout}        40s
${EMAIL}          test@r1.com
${PASSWORD}       Naresh
${SCREENSHOT_DIR}    screenshots

*** Test Cases ***
Full Restaurant Flow
    [Documentation]    Login as restaurant and list invoices for Careem, Talabat, and Noon (2 times each with random discount).
    [Tags]    fullflow    restaurant

    Login to Platform as Restaurant

    ${grand_total}=    Set Variable    0

    List Multiple Invoices For Brand    Careem
    ${dashboard_total}=    Get Total Funding Received

    List Multiple Invoices For Brand    Talabat
    ${dashboard_total}=    Get Total Funding Received

    List Multiple Invoices For Brand    Noon
    ${dashboard_total}=    Get Total Funding Received

*** Keywords ***
Login to Platform as Restaurant
    ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome options}    add_argument    --headless
    Call Method    ${chrome options}    add_argument    --disable-gpu
    Call Method    ${chrome options}    add_argument    --no-sandbox
    Call Method    ${chrome options}    add_argument    --disable-dev-shm-usage
    ${size}=    Set Variable    --window-size=1920,1080
    Call Method    ${chrome options}    add_argument    ${size}



    Open Browser    ${URL}    chrome    options=${chrome options}
    Maximize Browser Window

    Wait Until Element Is Visible    xpath=//input[@placeholder="Enter your email"]    ${Timeout}
    Input Text    xpath=//input[@placeholder="Enter your email"]    ${EMAIL}
    Input Text    xpath=//input[@placeholder="Enter your password"]    ${PASSWORD}
    Click Element    xpath=//button[text()="Login"]
    Sleep   3s

List Multiple Invoices For Brand
    [Arguments]    ${brand}
    FOR    ${i}    IN RANGE    2
        List Single Invoice For Brand    ${brand}
    END

List Single Invoice For Brand
    [Arguments]    ${brand}
    Wait Until Element Is Visible    xpath=//a[@href="/restaurant/invoice-financing"]    ${Timeout}
    Click Element    xpath=//a[@href="/restaurant/invoice-financing"]
    Wait Until Element Is Visible    xpath=//h1[text()="Invoice Financing"]    ${Timeout}

    ${discount}=    Evaluate    random.randint(10,15)    random
    ${brand_xpath}=    Set Variable    //img[contains(@src, '${brand}.png')]/ancestor::div[@data-slot='card']//button[normalize-space()='Finance']
    
    # Scroll Element Into View    ${brand_xpath}
    Wait Until Element Is Visible    ${brand_xpath}    ${Timeout}
    Click Element    ${brand_xpath}
    Sleep  2s

    Wait Until Element Is Visible    xpath=(//input)[1]    ${Timeout}
    Input Text    xpath=(//input)[1]    100
    Input Text    xpath=(//input)[2]    ${discount}
    Sleep  2s

    Wait Until Element Is Enabled    xpath=//button[normalize-space()='Sell Invoices']    ${Timeout}
    Click Element    xpath=//button[normalize-space()='Sell Invoices']
    Wait Until Element Is Visible    xpath=//button[text()='Go to My Requests']    ${Timeout}
    Click Element    xpath=//button[text()='Go to My Requests']
    Sleep  3s
    Reload Page
    Wait Until Element Is Visible    xpath=//h1[text()="My Requests"]    ${Timeout}

Get Total Funding Received
    Wait Until Element Is Visible    xpath=//a[@href="/restaurant/dashboard"]    ${Timeout}
    Click Element    xpath=//a[@href="/restaurant/dashboard"]

    Wait Until Element Is Visible    xpath=//span[normalize-space()='Total Funding Received']/ancestor::div[@data-slot='card-header']/following-sibling::div[@data-slot='card-content']//div    ${Timeout}
    ${funding_text}=    Get Text    xpath=//span[normalize-space()='Total Funding Received']/ancestor::div[@data-slot='card-header']/following-sibling::div[@data-slot='card-content']//div
    ${funding_text}=    Remove String    ${funding_text}    AED
    ${funding_text}=    Replace String    ${funding_text}    ,    ${EMPTY}
    ${funding}=    Convert To Number    ${funding_text}
    [Return]    ${funding}
