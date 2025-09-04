*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem
Library           BuiltIn
Library           Process
Library           String
Library           JSONLibrary
Library           Collections
Test Teardown     Take Screenshot On Failure

*** Variables ***
${BROWSER}        chrome
${URL}            https://rest-fin-fe.mangoforest-55e2394a.centralindia.azurecontainerapps.io/
${Timeout}        40s
${EMAIL}          test@r1.com
${PASSWORD}       Naresh

*** Test Cases ***
Full Restaurant Flow
    [Documentation]    Login as restaurant and list invoices for Careem, Talabat, and Noon (10 times each with random discount).
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
    # Create Chrome Options for GitHub Actions
    ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome options}    add_argument    --headless
    Call Method    ${chrome options}    add_argument    --disable-gpu
    Call Method    ${chrome options}    add_argument    --no-sandbox
    Call Method    ${chrome options}    add_argument    --disable-dev-shm-usage

    # Open Browser with options
    Open Browser    ${URL}    chrome    options=${chrome options}
    Maximize Browser Window

    Wait Until Element Is Visible    xpath=//input[@placeholder="Enter your email"]    ${Timeout}
    Input Text    xpath=//input[@placeholder="Enter your email"]    ${EMAIL}
    Input Text    xpath=//input[@placeholder="Enter your password"]    ${PASSWORD}
    Click Element    xpath=//button[text()="Login"]

Connect to the platform and navigate to User Dashboard
    [Documentation]    This test case connects to the platform and navigates to the user dashboard.
    [Tags]    connect    dashboard 
    Wait Until Element Is Visible    xpath=//div[@data-slot="card"][.//img[@alt="talabat"]]   ${Timeout}
    Sleep   2s
    ${isTalabatConnected}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//div[@data-slot="card"][.//img[@alt="talabat"]]//button[normalize-space()="Connect"]
    Run Keyword If    ${isTalabatConnected}     Click Element    xpath=//div[@data-slot="card"][.//img[@alt="talabat"]]//button[normalize-space()="Connect"]

    Wait Until Element Is Visible    xpath=//div[@data-slot="card"][.//img[@alt="noonfood"]]   ${Timeout}
    Sleep   2s
    ${isNoonFoodConnected}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//div[@data-slot="card"][.//img[@alt="noonfood"]]//button[normalize-space()="Connect"]
    Run Keyword If    ${isNoonFoodConnected}     Click Element    xpath=//div[@data-slot="card"][.//img[@alt="noonfood"]]//button[normalize-space()="Connect"]

    Wait Until Element Is Visible    xpath=//div[@data-slot="card"][.//img[@alt="careem"]]   ${Timeout}
    Sleep   2s
    ${isCareemConnected}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//div[@data-slot="card"][.//img[@alt="careem"]]//button[normalize-space()="Connect"]
    Run Keyword If    ${isCareemConnected}     Click Element    xpath=//div[@data-slot="card"][.//img[@alt="careem"]]//button[normalize-space()="Connect"]

    Wait Until Element Is Visible    xpath=//button[normalize-space()="Go to Dashboard"]    ${Timeout}
    Click Element    xpath=//button[normalize-space()="Go to Dashboard"]

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
    Wait Until Element Is Visible    ${brand_xpath}    ${Timeout}
    Click Element    ${brand_xpath}
    Wait Until Element Is Visible    xpath=(//input)[1]    ${Timeout}
    Input Text    xpath=(//input)[1]    100
    Input Text    xpath=(//input)[2]    ${discount}
    Sleep    2s
    Wait Until Element Is Enabled    xpath=//button[normalize-space()='Sell Invoices']    ${Timeout}
    Click Element    xpath=//button[normalize-space()='Sell Invoices']
    Wait Until Element Is Visible    xpath=//button[text()='Go to My Requests']    ${Timeout}
    Click Element    xpath=//button[text()='Go to My Requests']
    Sleep  5s
    Reload Page
    Wait Until Element Is Visible    xpath=//h1[text()="My Requests"]    ${Timeout}

Calculate Total Funding Received
    [Documentation]    Calculates the total funding received for fulfilled requests and returns it
    Wait Until Element Is Visible    xpath=//a[@href="/restaurant/requests"]    ${Timeout}
    Click Element    xpath=//a[@href="/restaurant/requests"]

    Wait Until Element Is Visible    xpath=//table//tr    ${Timeout}
    ${rows}=    Get WebElements    //table//tr
    ${total}=    Set Variable    0
    ${row_count}=    Get Length    ${rows}
    Log    Found ${row_count} table rows.

    FOR    ${index}    IN RANGE    2    ${row_count+1}
        ${status}=    Get Text    (//table//tr)[${index}]/td[last()]
        ${status}=    Convert To Upper Case    ${status}

        IF    '${status}' == 'FULFILLED'
            ${funding}=    Get Text    (//table//tr)[${index}]/td[last()-1]
            ${funding}=    Remove String    ${funding}    AED
            ${funding}=    Replace String    ${funding}    ,    ${EMPTY}
            ${funding}=    Convert To Number    ${funding}
            ${total}=    Evaluate    ${total} + ${funding}
        END
    END
    Log    Total Funding Received (FULFILLED): ${total}
    [Return]    ${total}

Get Total Funding Received
    [Documentation]    Extracts the total funding received value from dashboard and returns as a number

    Wait Until Element Is Visible    xpath=//a[@href="/restaurant/dashboard"]    ${Timeout}
    Click Element    xpath=//a[@href="/restaurant/dashboard"]

    Wait Until Element Is Visible    xpath=//span[normalize-space()='Total Funding Received']/ancestor::div[@data-slot='card-header']/following-sibling::div[@data-slot='card-content']//div    ${Timeout}
    ${funding_text}=    Get Text    xpath=//span[normalize-space()='Total Funding Received']/ancestor::div[@data-slot='card-header']/following-sibling::div[@data-slot='card-content']//div
    Log    Raw Funding Text: ${funding_text}
    ${funding_text}=    Remove String    ${funding_text}    AED
    ${funding_text}=    Replace String    ${funding_text}    ,    ${EMPTY}
    ${funding}=    Convert To Number    ${funding_text}
    Log    Numeric Funding Value: ${funding}
    [Return]    ${funding}
    
Take Screenshot On Failure
    [Documentation]    Capture screenshot if the test failed
    ${test_status}=    Get Test Status
    Run Keyword If    '${test_status}' == 'FAIL'    Capture Page Screenshot
    Close Browser
