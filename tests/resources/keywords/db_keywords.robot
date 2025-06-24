*** Settings ***
Library     Process
Resource    util_keywords.robot
Resource    auth_keywords.robot
Resource    db_keywords.robot

*** Keywords ***
Save Purchase In Database
    [Documentation]    Save complete entry (with or without errors) to database
    [Arguments]    ${testcase}    ${user}    ${product_name}    ${price}    ${error}    ${error_description}
    Log To Console    \n letzter Schritt Speichern in die DB (lade insert_purchase.py)
    Log To Console    \n Daten zu speichern: user: ${user} | product_name: ${product_name} | price: ${price} | error: ${error} | error_description: ${error_description}
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
    Log To Console    stdout ${run.stdout}
    Log To Console    stderr ${run.stderr}
Save Entries To Database
    [Arguments]    ${entries}
    Log To Console    \n Schritt befehl zum speichern

    ${testcase}=               Get From List    ${entries}    0
    ${user}=                   Get From List    ${entries}    1
    ${product_name}=           Get From List    ${entries}    2
    ${price}=                  Get From List    ${entries}    3
    ${error}=                  Get From List    ${entries}    4
    ${error_description}=      Get From List    ${entries}    5

    Log To Console
    ...    \n 💾 Datenbankeintrag: ${testcase} | ${user} | ${product_name} | ${price} | ${error} | ${error_description}

    Save Purchase In Database    ${testcase}    ${user}    ${product_name}    ${price}    ${error}    ${error_description}

Collect Database Entries
    [Arguments]    ${testcase}    ${user}=${None}    ${product_name}=${None}    ${price}=${None}    ${error}=${None}    ${error_description}=${None}
    Log To Console    \n Schritt zusammenstellen der DB Einträge

    Set Entry If Needed    ${entries}    0    ${testcase}
    Set Entry If Needed    ${entries}    1    ${user}
    Set Entry If Needed    ${entries}    2    ${product_name}
    Set Entry If Needed    ${entries}    3    ${price}
    Set Entry If Needed    ${entries}    4    ${error}
    Set Entry If Needed    ${entries}    5    ${error_description}

    RETURN    ${entries}
Set Entry If Needed
    [Arguments]    ${list}    ${index}    ${new_value}
    ${old_value}=    Get From List    ${list}    ${index}

    IF    $old_value is None and $new_value is not None
        Set List Value    ${list}    ${index}    ${new_value}
    ELSE IF    $old_value is not None and $new_value is not None
        Log To Console    \nEINTRAG NICHT GESETZT, WEIL SONST ÜBERSCHRIEBEN an Index ${index}! Alt: ${old_value}, Neu: ${new_value}    WARN
    END
