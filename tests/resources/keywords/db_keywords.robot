*** Settings ***
Library     Process
Resource    ./util_keywords.robot
Resource    ./auth_keywords.robot
Resource    ./db_keywords.robot

*** Keywords ***
Save Entries To Database
    [Documentation]    Save complete entry (with or without errors) to database
    [Arguments]    ${testcase}    ${user}    ${product_name}    ${price}    ${result}    ${error}    ${error_description}

    ${testcase}=               Get From List    ${global_entries}    0
    ${user}=                   Get From List    ${global_entries}    1
    ${product_name}=           Get From List    ${global_entries}    2
    ${price}=                  Get From List    ${global_entries}    3
    ${result}=                 Get From List    ${global_entries}    4
    ${error}=                  Get From List    ${global_entries}    5
    ${error_description}=      Get From List    ${global_entries}    6

    Log To Console    \nSpeichern in die DB (lade insert_purchase.py)
    Log To Console    \nDaten zum speichern: testcase: ${testcase} | user: ${user} | product_name: ${product_name} | price: ${price} | result: ${result} | error: ${error} | error_description: ${error_description}

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

Collect Database Entries
    [Arguments]    ${testcase}=${None}    ${user}=${None}    ${product_name}=${None}    ${price}=${None}    ${result}=${None}    ${error}=${None}    ${error_description}=${None}

    Write To Global    0    ${testcase}
    Write To Global    1    ${user}
    Write To Global    2    ${product_name}
    Write To Global    3    ${price}
    Write To Global    4    ${result}
    Write To Global    5    ${error}
    Write To Global    6    ${error_description}

Set Test Entries
    [Arguments]    ${testcase}    ${user}
    Write To Global    0    ${testcase}
    Write To Global    1    ${user}

#    Collect Database Entries    ${testcase}    ${user}    ${None}    ${None}    ${None}    ${None}    ${None}

Set Error Entries
    [Arguments]    ${error}    ${error_describtion}
    Write To Global    5    ${error}
    Write To Global    6    ${error_describtion}

#    Collect Database Entries    ${None}    ${None}    ${None}    ${None}    ${None}    ${error}    ${error_describtion}

Set Purchase Entries
    [Arguments]    ${product_name}    ${price}
    Write To Global    2    ${product_name}
    Write To Global    3    ${price}

#    Collect Database Entries    ${None}    ${None}    ${product_name}    ${price}    ${None}    ${None}    ${None}

Write To Global
    [Arguments]    ${index}    ${new_value}
    Set List Value    ${global_entries}    ${index}    ${new_value}
