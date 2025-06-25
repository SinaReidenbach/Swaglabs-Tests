*** Settings ***
Library     Process
Resource    ./util_keywords.robot
Resource    ./auth_keywords.robot
Resource    ./db_keywords.robot

*** Keywords ***
Save Entries To Database
    [Documentation]    Save complete entry (with or without errors) to database

    ${testcase}
    ...    ${user}
    ...    ${product_name}
    ...    ${price}
    ...    ${result}
    ...    ${error}
    ...    ${error_description}=
    ...    Set Variable    @{GLOBAL_ENTRIES}

    ${run}=    Run Process
    ...    python
    ...    ../../../db/insert_purchase.py
    ...    ${testcase}
    ...    ${user}
    ...    ${product_name}
    ...    ${price}
    ...    ${result}
    ...    ${error}
    ...    ${error_description}
    ...    shell=True
    ...    cwd=${CURDIR}

Reset Global
    Set Suite Variable    @{GLOBAL_ENTRIES}    ${None}    ${None}    ${None}    ${None}    ${None}    ${None}    ${None}

Write To Global
    [Arguments]    ${index}    ${new_value}
    Set List Value    ${GLOBAL_ENTRIES}    ${index}    ${new_value}

Set Test Entries
    [Arguments]    ${testcase}    ${user}
    Write To Global    0    ${testcase}
    Write To Global    1    ${user}

Set Error Entries
    [Arguments]    ${error}    ${error_describtion}
    Write To Global    5    ${error}
    Write To Global    6    ${error_describtion}

Set Purchase Entries
    [Arguments]    ${product_name}    ${price}
    Write To Global    2    ${product_name}
    Write To Global    3    ${price}
