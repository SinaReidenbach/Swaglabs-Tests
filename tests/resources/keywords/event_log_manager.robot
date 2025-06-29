*** Settings ***
Documentation       Event Log Keywords

Library             Collections
Library             Process
Library             ./python/insert_purchase.py


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
            Insert Purchase To Db
            ...    ${testcase}
            ...    ${user}
            ...    ${product_name}
            ...    ${price}
            ...    PASS
            ...    ${None}
            ...    ${None}
        END
        FOR    ${error}    IN    @{errors}
            ${err}=    Set Variable    ${error['error']}
            ${error_description}=    Set Variable    ${error['error_description']}
            ${error_source}=    Set Variable    ${error['error_source']}
            IF    'SELENIUM' in $error_source
                ${result}=    Set Variable    FAIL
            ELSE
                ${result}=    Set Variable    ${None}
            END
            Insert Purchase To Db
            ...    ${testcase}
            ...    ${user}
            ...    ${product_name}
            ...    ${price}
            ...    ${result}
            ...    ${err}
            ...    ${error_description}
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

    Add To Dictionary    errors    ${error}

Set Purchase Entries
    [Documentation]    Set values for ${product_name} and ${price}
    [Arguments]    ${product_name}    ${price}

    ${purchase}=    Create Dictionary
    ...    product_name=${product_name}
    ...    price=${price}

    Add To Dictionary    purchases    ${purchase}

Add To Dictionary
    [Arguments]    ${dict_name}    ${dict}
    ${has_entry}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${EVENT_LOG}    ${dict_name}
    IF    ${has_entry}
        ${current}=    Get From Dictionary    ${EVENT_LOG}    ${dict_name}
    ELSE
        ${current}=    Create List
    END
    Append To List    ${current}    ${dict}
    Set To Dictionary    ${EVENT_LOG}    ${dict_name}=${current}
