*** Settings ***
Library     Process
Resource    util_keywords.robot
Resource    auth_keywords.robot
Resource    db_keywords.robot

*** Keywords ***
Save Purchase In Database
    [Documentation]    Save complete entry (with or without errors) to database
    [Arguments]    ${user}    ${product_name}    ${price}    ${error}    ${error_description}
    Log To Console    \n letzter Schritt Speichern in die DB (lade insert_purchase.py)
    Log To Console    \n Daten zu speichern: user: ${user} | product_name: ${product_name} | price: ${price} | error: ${error} | error_description: ${error_description}
    ${run}=    Run Process
    ...    python
    ...    ../../../db/insert_purchase.py
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
    [Arguments]
    Log To Console    \n Schritt befehl zum speichern

    ${entries}=                Set Variable    @{ORIGINAL}
    ${user}=                   Get From List    ${entries}    0
    ${product_name}=           Get From List    ${entries}    1
    ${price}=                  Get From List    ${entries}    2
    ${error}=                  Get From List    ${entries}    3
    ${error_description}=      Get From List    ${entries}    4

    Log To Console
    ...    \n 💾 Datenbankeintrag: ${user} | ${product_name} | ${price} | ${error} | ${error_description}

    Save Purchase In Database    ${user}    ${product_name}    ${price}    ${error}    ${error_description}

#    ${entries}=    Set Variable    ${None}
#    Set Suite Variable    @{ORIGINAL}    @{ORIGINAL}
Collect Database Entries
    [Arguments]    ${user}=${None}    ${product_name}=${None}    ${price}=${None}    ${error}=${None}    ${error_description}=${None}
    Log To Console    \n Schritt zusammenstellen der DB Einträge

    ${original}=    Create List    ${None}    ${None}    ${None}    ${None}    ${None}

    @{new_args}=    Create List    ${user}    ${product_name}    ${price}    ${error}    ${error_description}

    @{entries}=    Create List

    FOR    ${index}    IN RANGE    0    5
        ${new}=    Get From List    ${new_args}    ${index}
        ${old}=    Get From List    ${original}    ${index}
        Run Keyword If    $new != '' and $new != $NONE
        ...    Append To List    ${entries}    ${new}
        ...  ELSE
        ...    Append To List    ${entries}    ${old}
    END
    Log To Console    \n zusammengestellte Daten: ${entries}
    Log To Console    \n ORIGINAL wird aktualisiert
    Set Suite Variable    @{ORIGINAL}    @{entries}
    RETURN    ${entries}
