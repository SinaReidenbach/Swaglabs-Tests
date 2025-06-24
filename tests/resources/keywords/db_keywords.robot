*** Settings ***
Library     Process
Resource    util_keywords.robot
Resource    auth_keywords.robot
Resource    db_keywords.robot

*** Keywords ***
Save Entries To Database
    [Documentation]    Save complete entry (with or without errors) to database
    [Arguments]    ${testcase}    ${user}    ${product_name}    ${price}    ${error}    ${error_description}

    ${testcase}=               Get From List    ${global_entries}    0
    ${user}=                   Get From List    ${global_entries}    1
    ${product_name}=           Get From List    ${global_entries}    2
    ${price}=                  Get From List    ${global_entries}    3
    ${error}=                  Get From List    ${global_entries}    4
    ${error_description}=      Get From List    ${global_entries}    5


    Log To Console    \nSpeichern in die DB (lade insert_purchase.py)
    Log To Console    \nDaten zum speichern: user: ${user} | product_name: ${product_name} | price: ${price} | error: ${error} | error_description: ${error_description}

    ${run}=    Run Process
    ...    python
    ...    ../../../db/insert_purchase.py
    ...    ${testcase}
    ...    ${user}
    ...    ${product_name}
    ...    ${price}
    ...    ${error}
    ...    ${error_description}
    ...    shell=True
    ...    cwd=${CURDIR}

Collect Database Entries
    [Arguments]    ${testcase}=${None}    ${user}=${None}    ${product_name}=${None}    ${price}=${None}    ${error}=${None}    ${error_description}=${None}

    Set Entry If Needed    ${global_entries}    0    ${testcase}
    Set Entry If Needed    ${global_entries}    1    ${user}
    Set Entry If Needed    ${global_entries}    2    ${product_name}
    Set Entry If Needed    ${global_entries}    3    ${price}
    Set Entry If Needed    ${global_entries}    4    ${error}
    Set Entry If Needed    ${global_entries}    5    ${error_description}

    RETURN    ${global_entries}

Set Test Entries
    [Arguments]    ${testcase}    ${user}
    Set Entry If Needed    ${global_entries}    0    ${testcase}
    Set Entry If Needed    ${global_entries}    1    ${user}

    Collect Database Entries    ${testcase}    ${user}    ${None}    ${None}    ${None}    ${None}

Set Error Entries
    [Arguments]    ${error}    ${error_describtion}
    Set Entry If Needed    ${global_entries}    4    ${error}
    Set Entry If Needed    ${global_entries}    5    ${error_describtion}

    Collect Database Entries    ${None}    ${None}    ${None}    ${None}    ${error}    ${error_describtion}

Set Purchase Entries
    [Arguments]    ${product_name}    ${price}
    Set Entry If Needed    ${global_entries}    2    ${product_name}
    Set Entry If Needed    ${global_entries}    3    ${price}

    Collect Database Entries    ${None}    ${None}    ${product_name}    ${price}    ${None}    ${None}

Set Entry If Needed
    [Arguments]    ${list}    ${index}    ${new_value}    &{replace}
    ${old_value}=    Get From List    ${list}    ${index}

    IF    $new_value == 'replace'
        Set List Value    ${list}    ${index}    ${None}
    ELSE IF    $old_value is None and $new_value is not None
        Set List Value    ${list}    ${index}    ${new_value}
    ELSE IF    $old_value is not None and $new_value is not None
        Log To Console    \nEINTRAG NICHT GESETZT, WEIL SONST ÜBERSCHRIEBEN an Index ${index}! Alt: ${old_value}, Neu: ${new_value}    WARN
    END
