# *** Settings ***
# Library           SeleniumLibrary
# Library           OperatingSystem
# Library           BuiltIn
# Library           Process
# Library           String
# Library           JSONLibrary
# Library           Collections

# *** Variables ***
# ${BROWSER}        chrome
# ${URL}            https://rest-fin-fe.mangoforest-55e2394a.centralindia.azurecontainerapps.io/
# ${Timeout}        40s
# ${EMAIL}          test@r1.com
# ${PASSWORD}       Naresh
# ${SCREENSHOT_DIR}    screenshots

# *** Test Cases ***
# Full Restaurant Flow
#     [Documentation]    Login as restaurant and list invoices for Careem, Talabat, and Noon (2 times each with random discount).
#     [Tags]    fullflow    restaurant

#     Login to Platform as Restaurant

#     ${grand_total}=    Set Variable    0

#     List Multiple Invoices For Brand    Careem
#     ${dashboard_total}=    Get Total Funding Received

#     List Multiple Invoices For Brand    Talabat
#     ${dashboard_total}=    Get Total Funding Received

#     List Multiple Invoices For Brand    Noon
#     ${dashboard_total}=    Get Total Funding Received

# *** Keywords ***
# Login to Platform as Restaurant
#     ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
#     Call Method    ${chrome options}    add_argument    --headless
#     Call Method    ${chrome options}    add_argument    --disable-gpu
#     Call Method    ${chrome options}    add_argument    --no-sandbox
#     Call Method    ${chrome options}    add_argument    --disable-dev-shm-usage
#     ${size}=    Set Variable    --window-size=1920,1080
#     Call Method    ${chrome options}    add_argument    ${size}



#     Open Browser    ${URL}    chrome    options=${chrome options}
#     Maximize Browser Window

#     Wait Until Element Is Visible    xpath=//input[@placeholder="Enter your email"]    ${Timeout}
#     Input Text    xpath=//input[@placeholder="Enter your email"]    ${EMAIL}
#     Input Text    xpath=//input[@placeholder="Enter your password"]    ${PASSWORD}
#     Click Element    xpath=//button[text()="Login"]
#     Sleep   3s

# List Multiple Invoices For Brand
#     [Arguments]    ${brand}
#     FOR    ${i}    IN RANGE    2
#         List Single Invoice For Brand    ${brand}
#     END

# List Single Invoice For Brand
#     [Arguments]    ${brand}
#     Wait Until Element Is Visible    xpath=//a[@href="/restaurant/invoice-financing"]    ${Timeout}
#     Click Element    xpath=//a[@href="/restaurant/invoice-financing"]
#     Wait Until Element Is Visible    xpath=//h1[text()="Invoice Financing"]    ${Timeout}

#     ${discount}=    Evaluate    random.randint(10,15)    random
#     ${brand_xpath}=    Set Variable    //img[contains(@src, '${brand}.png')]/ancestor::div[@data-slot='card']//button[normalize-space()='Finance']
    
#     # Scroll Element Into View    ${brand_xpath}
#     Wait Until Element Is Visible    ${brand_xpath}    ${Timeout}
#     Click Element    ${brand_xpath}
#     Sleep  2s

#     Wait Until Element Is Visible    xpath=(//input)[1]    ${Timeout}
#     Input Text    xpath=(//input)[1]    100
#     Input Text    xpath=(//input)[2]    ${discount}
#     Sleep  2s

#     Wait Until Element Is Enabled    xpath=//button[normalize-space()='Sell Invoices']    ${Timeout}
#     Click Element    xpath=//button[normalize-space()='Sell Invoices']
#     Wait Until Element Is Visible    xpath=//button[text()='Go to My Requests']    ${Timeout}
#     Click Element    xpath=//button[text()='Go to My Requests']
#     Sleep  3s
#     Reload Page
#     Wait Until Element Is Visible    xpath=//h1[text()="My Requests"]    ${Timeout}

# Get Total Funding Received
#     Wait Until Element Is Visible    xpath=//a[@href="/restaurant/dashboard"]    ${Timeout}
#     Click Element    xpath=//a[@href="/restaurant/dashboard"]

#     Wait Until Element Is Visible    xpath=//span[normalize-space()='Total Funding Received']/ancestor::div[@data-slot='card-header']/following-sibling::div[@data-slot='card-content']//div    ${Timeout}
#     ${funding_text}=    Get Text    xpath=//span[normalize-space()='Total Funding Received']/ancestor::div[@data-slot='card-header']/following-sibling::div[@data-slot='card-content']//div
#     ${funding_text}=    Remove String    ${funding_text}    AED
#     ${funding_text}=    Replace String    ${funding_text}    ,    ${EMPTY}
#     ${funding}=    Convert To Number    ${funding_text}
#     [Return]    ${funding}


# ************************************************

*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem
Library           BuiltIn
Library           Process
Library           String
Library           JSONLibrary
Library           Collections
Library           DateTime
Test Teardown     Close All Browsers

*** Variables ***
${BROWSER}        chrome
${URL}            https://rest-fin-fe.mangoforest-55e2394a.centralindia.azurecontainerapps.io/
${Timeout}        40s
${SELL_AMOUNT}        1000
${SELL_DISCOUNT}      2
${BUY_AMOUNT}         1000
${BUY_DISCOUNT}       2
${REST_EMAIL}         test@r10.com
${PASSWORD}           Naresh
${FIN_EMAIL}          test@f10.com

*** Test Cases ***
End To End Sell-Buy Fulfillment
    [Documentation]    Restaurant sells at 2% discount (1000), Financier buys at 1% (1000), wait until fulfilled and measure time
    Login As Restaurant  
    Sleep    2s
    Place Restaurant Sell Order    Careem
    Place Restaurant Sell Order    Talabat
    Place Restaurant Sell Order    Noon
    Close Browser

    Login As Financier  
    Sleep    2s
    Place And Wait For Buy Fulfillment    Careem
    Place And Wait For Buy Fulfillment    Talabat
    Place And Wait For Buy Fulfillment    Noon


*** Keywords ***
Login As Restaurant
    ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome options}    add_argument    --headless
    Call Method    ${chrome options}    add_argument    --disable-gpu
    Call Method    ${chrome options}    add_argument    --no-sandbox
    Call Method    ${chrome options}    add_argument    --disable-dev-shm-usage
    ${size}=    Set Variable    --window-size=1920,1080
    Call Method    ${chrome options}    add_argument    ${size}

    Open Browser    ${URL}    chrome    options=${chrome options}
    # Open Browser    ${URL}    firefox
    Maximize Browser Window

    Wait Until Element Is Visible    xpath=//input[@placeholder="Enter your email"]    ${Timeout}
    Input Text    xpath=//input[@placeholder="Enter your email"]    ${REST_EMAIL}
    Input Text    xpath=//input[@placeholder="Enter your password"]    ${PASSWORD}
    Click Element    xpath=//button[text()="Login"]

Login As Financier
    ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome options}    add_argument    --headless
    Call Method    ${chrome options}    add_argument    --disable-gpu
    Call Method    ${chrome options}    add_argument    --no-sandbox
    Call Method    ${chrome options}    add_argument    --disable-dev-shm-usage
    ${size}=    Set Variable    --window-size=1920,1080
    Call Method    ${chrome options}    add_argument    ${size}

    Open Browser    ${URL}    chrome    options=${chrome options}
    # Open Browser    ${URL}    firefox
    Maximize Browser Window

    Wait Until Element Is Visible    xpath=//input[@placeholder="Enter your email"]    ${Timeout}
    Input Text    xpath=//input[@placeholder="Enter your email"]    ${FIN_EMAIL}
    Input Text    xpath=//input[@placeholder="Enter your password"]    ${PASSWORD}
    Click Element    xpath=//button[text()="Login"]

Place Restaurant Sell Order
    [Arguments]    ${brand}
    Wait Until Element Is Visible    xpath=//a[@href="/restaurant/invoice-financing"]    ${Timeout}
    Sleep   1s
    Click Element    xpath=//a[@href="/restaurant/invoice-financing"]
    ${brand_xpath}=    Set Variable    //img[contains(@src, '${brand}.png')]/ancestor::div[@data-slot='card']//button[normalize-space()='Finance']
    Wait Until Element Is Visible    ${brand_xpath}    ${Timeout}
    Click Element    ${brand_xpath}
    Wait Until Element Is Visible    xpath=(//input)[1]    ${Timeout}
    Input Text    xpath=(//input)[1]    ${SELL_AMOUNT}
    Input Text    xpath=(//input)[2]    ${SELL_DISCOUNT}
    Wait Until Element Is Enabled    xpath=//button[normalize-space()='Sell Invoices']    ${Timeout}
    Click Element    xpath=//button[normalize-space()='Sell Invoices']
    Wait Until Element Is Visible    xpath=//button[text()='Go to My Requests']    ${Timeout}
    Click Element    xpath=//button[text()='Go to My Requests']
    Sleep    3s

Place And Wait For Buy Fulfillment
    [Arguments]    ${brand}
    Wait Until Element Is Visible    xpath=//a[@href="/financer/marketplace"]    ${Timeout}
    Sleep   1s
    Click Element    xpath=//a[@href="/financer/marketplace"]
    ${brand_xpath}=    Set Variable    //img[contains(@src, '${brand}.png')]/ancestor::div[@data-slot='card']//button[normalize-space()='Trade']
    Wait Until Element Is Visible    ${brand_xpath}    ${Timeout}
    Click Element    ${brand_xpath}
    Execute JavaScript       document.querySelector('main').scrollTop += 500;
    Wait Until Element Is Visible    xpath=(//input)[1]    ${Timeout}
    Sleep   1s
    Input Text    xpath=(//input)[1]    ${BUY_DISCOUNT}
    Sleep   1s
    Input Text    xpath=(//input)[2]    ${BUY_AMOUNT}
    Sleep   1s
    ${start_time}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Wait Until Element Is Enabled    (//button[normalize-space()='Buy Tokens'])    ${Timeout}
    Click Element    (//button[normalize-space()='Buy Tokens'])
    Wait Until Element Is Visible    xpath=//button[text()='Go to My Tradebook']    ${Timeout}
    Click Element    xpath=//button[text()='Go to My Tradebook']

    FOR    ${i}    IN RANGE    50
        Sleep    2s
        Reload Page
        Wait Until Element Is Visible    xpath=//h1[text()="My Tradebook"]    ${Timeout} 
        Wait Until Element Is Visible    xpath=//table//tr     ${Timeout}  
        ${status}=    Get Text    (//table//tr)[2]/td[last()]
        ${status}=    Convert To Upper Case    ${status}
        Run Keyword If    '${status}'=='FULFILLED'    Exit For Loop
    END

    ${end_time}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${duration}=    Subtract Date From Date    ${end_time}    ${start_time}
    ${msg}=    Catenate    >>> Order for ${brand} fulfilled in ${duration} <<<
    Log To Console    ${msg}

