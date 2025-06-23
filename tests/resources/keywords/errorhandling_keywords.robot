*** Settings ***
Library     Collections
Library     String
Library     SeleniumLibrary
Resource    util_keywords.robot
Resource    ../data/login_data.resource
Resource    ../data/error_data.resource


*** Keywords ***
Error Message Selenium
    [Documentation]    convert selenium-errors to understandable error-messages
    [Arguments]    ${user}    ${error}
    Log To Console    \n Schritt Fehler aus error_map lesen und errormessage formulieren
    ${message_lower}=    Convert To Lowercase    ${error}
    ${mapped_message}=    Set Variable     ${user} :: ${error}

    FOR    ${key}    ${msg}    IN    &{ERROR_MAP}
        @{parts}=    Split String    ${key}    |
        ${found}=    Set Variable     True
        FOR    ${part}    IN    @{parts}
            IF    $part not in $message_lower
                ${found}=    Set Variable     False
                BREAK
            END
        END

        IF    '${found}' == 'True'
            ${mapped_message}=    Set Variable    ${user} : ${msg}
            BREAK
        END
    END

    Log
    ...    ❌ ${mapped_message} | ${error}
    ...    ERROR

    ${EMPTY}=    Create List
    Log To Console    \n Schritt weitergabe der Fehler an Sammlung der Entries
    ${entries}=    Collect Database Entries    ${EMPTY}    ${user}    ${NONE}    ${NONE}    ${error}    ${mapped_message}

Error Message JavaScript
    [Arguments]    ${user}    ${before}
    Log To Console    \n Schritt neue JavaScript Fehler aus Geckofile ermitteln
    Sleep    2s
    ${geckopath}=    Get latest Geckodriver Log
    ${after}=    Read latest Geckodriver Log    ${geckopath}
    @{unique_errors}=    Extract The Current JavaScript Error    ${after}    ${before}

    Log To Console    \n ermittelte JavaScript Fehler: ${unique_errors}

    FOR    ${error}    IN    @{unique_errors}
        Error Message Selenium
        ...    ${user}
        ...    ${error}
    END

Extract The Current JavaScript Error
    [Arguments]    ${after}    ${before}

    Log To Console    \n JavaScript Fehler aus Geckofile extrahieren
    ${after_lines}=    Split To Lines    ${after}
    ${before_lines}=   Split To Lines    ${before}

    ${new_lines}=    Create List

    FOR    ${line}    IN    @{after_lines}
        Run Keyword If    '${line}' not in ${before_lines}    Append To List    ${new_lines}    ${line}
    END

    ${unique_errors}=    Create List
    FOR    ${line}    IN    @{new_lines}
        Run Keyword If    'JavaScript error' in '${line}'    Run Keyword    Extract And Append Error    ${line}    ${unique_errors}
    END

    RETURN    ${unique_errors}

Remove Matching Lines
    [Arguments]    ${full}    ${exclude}
    ${result}=    Create List
    FOR    ${line}    IN    @{full}
        Run Keyword If    '${line}' not in ${exclude}    Append To List    ${result}    ${line}
    END
    RETURN    ${result}

Extract And Append Error
    [Arguments]    ${line}    ${error_list}
    ${lines}=    Split String    ${line}    ,
    ${error}=    Get From List    ${lines}    1
    ${error}=    Strip String    ${error}
    Run Keyword If    "${error}" not in ${error_list}    Append To List    ${error_list}    ${error}

Read Geckodriver Log
    ${geckopath}=    Get latest Geckodriver Log
    ${before}=    Read latest Geckodriver Log    ${geckopath}
    RETURN    ${before}

Run Error Check
    [Arguments]    ${user}    ${step_keyword}    @{args}
    ${before}=    Read Geckodriver Log
    TRY
        Run Keyword    ${step_keyword}    @{args}
        Error Message JavaScript    ${user}    ${before}
    EXCEPT    AS    ${error}
        Error Message Selenium    ${user}    ${error}
        Error Message JavaScript    ${user}    ${before}
    END
