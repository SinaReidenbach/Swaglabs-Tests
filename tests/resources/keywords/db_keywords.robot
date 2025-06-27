*** Settings ***
Library     Collections
Library     Process


*** Variables ***
${EVENT_LOG}    ${EMPTY}


*** Keywords ***
Save Entries To Database
    [Documentation]    Save complete entry (with or without errors) to database

    ${testcase}=    Set Variable    ${EVENT_LOG['testcase']}
    ${user}=    Set Variable    ${EVENT_LOG['username']}
    ${has_purchases}=    Evaluate    'purchases' in ${EVENT_LOG}
    IF    ${has_purchases}
        ${purchases}=    Set Variable    ${EVENT_LOG['purchases']}
    ELSE
        ${empty_purchase}=    Create Dictionary    product_name=${None}    price=${None}
        @{purchases}=    Create List    ${empty_purchase}
    END
    ${errors}=    Evaluate    ${EVENT_LOG}.get('errors', [])

    FOR    ${purchase}    IN    @{purchases}
        ${product_name}=    Set Variable    ${purchase['product_name']}
        ${price}=    Set Variable    ${purchase['price']}

        IF    $errors == []
            ${run}=    Run Process
            ...    python
            ...    ../../../db/insert_purchase.py
            ...    ${testcase}
            ...    ${user}
            ...    ${product_name}
            ...    ${price}
            ...    PASS
            ...    ${None}
            ...    ${None}
            ...    shell=True
            ...    cwd=${CURDIR}
        END
        FOR    ${error}    IN    @{errors}
            ${err}=    Set Variable    ${error['error']}
            ${error_description}=    Set Variable    ${error['error_description']}
            ${error_source}=    Set Variable    ${error['error_source']}
            Log To Console    ${error_source}
            IF    'SELENIUM' in $error_source
                ${result}=    Set Variable    FAIL
            ELSE
                ${result}=    Set Variable    ${None}
            END
            ${run}=    Run Process
            ...    python
            ...    ../../../db/insert_purchase.py
            ...    ${testcase}
            ...    ${user}
            ...    ${product_name}
            ...    ${price}
            ...    ${result}
            ...    ${err}
            ...    ${error_description}
            ...    shell=True
            ...    cwd=${CURDIR}
        END
    END

Init EventLog Per User
    [Arguments]    ${user}

    ${entry}=    Create Dictionary
    ...    testcase=${TEST_NAME}
    ...    username=${user}
    Set Suite Variable    ${EVENT_LOG}    ${entry}
    Log To Console    .

Set Error Entries
    [Documentation]    Set values for ${error} and ${error_description}
    [Arguments]    ${error}    ${error_description}    ${error_source}

    ${error}=    Create Dictionary
    ...    error=${error}
    ...    error_description=${error_description}
    ...    error_source=${error_source}

    ${has_errors}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${EVENT_LOG}    errors
    IF    ${has_errors}
        ${current_errors}=    Get From Dictionary    ${EVENT_LOG}    errors
    ELSE
        ${current_errors}=    Create List
    END
    Append To List    ${current_errors}    ${error}
    Set To Dictionary    ${EVENT_LOG}    errors=${current_errors}

Set Purchase Entries
    [Documentation]    Set values for ${product_name} and ${price}
    [Arguments]    ${product_name}    ${price}

    ${purchase}=    Create Dictionary
    ...    product_name=${product_name}
    ...    price=${price}

    ${has_purchases}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${EVENT_LOG}    purchases
    IF    ${has_purchases}
        ${current_purchases}=    Get From Dictionary    ${EVENT_LOG}    purchases
    ELSE
        ${current_purchases}=    Create List
    END
    Append To List    ${current_purchases}    ${purchase}
    Set To Dictionary    ${EVENT_LOG}    purchases=${current_purchases}
