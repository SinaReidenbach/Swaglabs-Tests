*** Settings ***
Library     Collections
Library     String
Library     SeleniumLibrary
Resource    util_keywords.robot
Resource    ../data/login_data.resource
Resource    ../data/error_data.resource


*** Keywords ***
Run Error Check
    [Arguments]    ${step_keyword}    @{args}
    ${before}=    Read Geckodriver Log
    TRY
        Run Keyword    ${step_keyword}    @{args}
        Check For New JavaScript Errors    ${before}
    EXCEPT    AS    ${error}
        Create Error Describtion    ${error}
        Check For New JavaScript Errors    ${before}
    END

Read Geckodriver Log
    ${geckopath}=    Get latest Geckodriver Log
    ${before}=    Read latest Geckodriver Log    ${geckopath}
    RETURN    ${before}

 Check For New JavaScript Errors
    [Arguments]    ${before}
    Sleep    2s
    ${geckopath}=    Get latest Geckodriver Log
    ${after}=    Read latest Geckodriver Log    ${geckopath}
    @{unique_errors}=    Extract The Current JavaScript Error    ${after}    ${before}

    FOR    ${error}    IN    @{unique_errors}
        Create Error Describtion
        ...    ${error}
    END

Create Error Describtion
    [Documentation]    Konvertiert Selenium-Fehlermeldungen in verständliche Texte aus ERROR_MAP
    [Arguments]    ${error}

    ${error_lower}=    Convert To Lowercase    ${error}

    FOR    ${key}    ${msg}    IN    &{ERROR_MAP}
        @{parts}=    Split String    ${key}    |
        ${found}=    Set Variable    True

        FOR    ${part}    IN    @{parts}
            IF    '${part}' not in "${error_lower}"
                ${found}=    Set Variable   False
            END
        END
            IF    '${found}' == 'True'
                ${error_describtion}=    Set Variable    ${msg}
            BREAK

        END
    END

    Log    ❌ ${error_describtion} | ${error}    ERROR

    Set Error Entries    ${error}    ${error_describtion}

    RETURN    ${error_describtion}

Extract The Current JavaScript Error
    [Arguments]    ${after}    ${before}

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

Extract And Append Error
    [Arguments]    ${line}    ${error_list}
    ${lines}=    Split String    ${line}    ,
    ${error}=    Get From List    ${lines}    1
    ${error}=    Strip String    ${error}
    Run Keyword If    "${error}" not in ${error_list}    Append To List    ${error_list}    ${error}
