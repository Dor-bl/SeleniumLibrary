*** Setting ***
Documentation     Tests Webdriver
Resource          resource.robot
Library           Collections

*** Test Cases ***
Create Webdriver Creates Functioning WebDriver
    [Documentation]
    ...    LOG 1:1 INFO REGEXP: Creating an instance of the \\w+ WebDriver.
    ...    LOG 1:19 DEBUG REGEXP: Created \\w+ WebDriver instance with session id (\\w|-)+.
    [Tags]    Known Issue Internet Explorer    Known Issue Safari
    [Setup]    Set Driver Variables
    Create Webdriver    ${DRIVER_NAME}    kwargs=${KWARGS}
    Go To    ${FRONT_PAGE}
    Wait Until Page Contains    needle    5s
    [Teardown]    Close Browser

Create Webdriver With Bad Driver Name
    [Documentation]    Invalid browser name
    Run Keyword And Expect Error    'Fireox' is not a valid WebDriver name.
    ...    Create Webdriver    Fireox

Create Webdriver With Duplicate Arguments
    [Documentation]    Invalid values in arguments
    ${kwargs}=    Create Dictionary    arg=1
    Run Keyword And Expect Error    Got multiple values for argument 'arg'.
    ...    Create Webdriver    Firefox    kwargs=${kwargs}    arg=2

Create Webdriver With Bad Keyword Argument Dictionary
    [Documentation]    Invalid arguments types
    ${status}    ${error} =    Run Keyword And Ignore Error    Create Webdriver    Firefox    kwargs={'spam': 'eggs'}
    Should Be Equal    ${status}    FAIL
    Should Match Regexp    ${error}    (TypeError: (?:WebDriver.)?__init__\\(\\) got an unexpected keyword argument 'spam'|kwargs must be a dictionary\.)

*** Keywords ***
Set Driver Variables
    [Documentation]    Selects proper driver
    ${drivers}=    Create Dictionary    ff=Firefox    firefox=Firefox    ie=Ie
    ...    internetexplorer=Ie    googlechrome=Chrome    gc=Chrome    chrome=Chrome
    ...    safari=Safari    headlesschrome=Chrome    headlessfirefox=Firefox
    ${name}=    Evaluate    "Remote" if "${REMOTE_URL}"!="None" else $drivers["${BROWSER}"]
    Set Test Variable    ${DRIVER_NAME}    ${name}
    ${dc names}=    Create Dictionary    ff=FIREFOX    firefox=FIREFOX    ie=INTERNETEXPLORER
    ...    internetexplorer=INTERNETEXPLORER    googlechrome=CHROME    gc=CHROME
    ...    chrome=CHROME    safari=SAFARI    headlessfirefox=FIREFOX    headlesschrome=CHROME
    ${dc name}=    Get From Dictionary    ${dc names}    ${BROWSER.lower().replace(' ', '')}
    ${caps}=    Evaluate    selenium.webdriver.DesiredCapabilities.${dc name}
    ...                     modules=selenium, selenium.webdriver
    ${kwargs}=    Create Dictionary
    Run Keyword If    "${name}"=="Remote"    Set To Dictionary    ${kwargs}    command_executor
    ...    ${REMOTE_URL}    desired_capabilities    ${caps}
    Set Test Variable    ${KWARGS}    ${kwargs}
