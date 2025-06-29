*** Settings ***
Documentation       Error Handling Keywords

Library             Collections
Library             SeleniumLibrary
Library             ./python/log_diff.py
Resource            ./util.robot
Resource            ../data/error.resource


*** Keywords ***
Run Error Check
    [Documentation]    performs an error check for a given keyword and creates an error description
    [Arguments]    ${step_keyword}    @{args}

    ${before}=    Read Geckodriver Log

    TRY
        Run Keyword    ${step_keyword}    @{args}
    EXCEPT    AS    ${error}
        Create Error Description    ${error}
        Fail    ${error}
    FINALLY
        Check For New JavaScript Errors    ${before}
    END

Read Geckodriver Log
    [Documentation]    Get the latest Geckodriver Log, reading and return the complete log

    ${geckopath}=    Get Latest Geckodriver Log
    ${actually}=    Read Latest Geckodriver Log    ${geckopath}

    RETURN    ${actually}

 Check For New JavaScript Errors
    [Documentation]    Get the latest Geckodriver Log, reading and extract JavaScript errors.
    ...    In connection create an error description
    [Arguments]    ${before}

    Sleep    2s

    ${after}=    Read Geckodriver Log
    @{unique_errors}=    Extract The Current JavaScript Error    ${after}    ${before}

    FOR    ${error}    IN    @{unique_errors}
        Create Error Description
        ...    ${error}
    END

Create Error Description
    [Documentation]    Convert error messages into understandable texts from ERROR_MAP
    [Arguments]    ${error}

    ${error_lower}=    Convert To Lowercase    ${error}
    FOR    ${key}    ${msg}    IN    &{ERROR_MAP}
        @{parts}=    Split String    ${key}    |
        ${found}=    Set Variable    True

        FOR    ${part}    IN    @{parts}
            IF    $part not in $error_lower
                ${found}=    Set Variable    False
            END
        END

        IF    '${found}' == 'True'
            ${error_description}=    Set Variable    ${msg}
            @{error_description_split}=    Split String    ${msg}    |
            BREAK
        END
    END

    Log    ❌ ${error_description} | ${error}    ERROR
    Set Error Entries    ${error}    ${error_description}    ${error_description_split[0]}

Extract The Current JavaScript Error
    [Documentation]    Compare the error messages before and after executing the keyword and
    ...    determine the new error message
    [Arguments]    ${after}    ${before}

    ${after_lines}=
    ...    Split To Lines    ${after}
    ${before_lines}=
    ...    Split To Lines    ${before}

    @{new_lines}=
    ...    Extract New Log Lines
    ...    ${after_lines}
    ...    ${before_lines}

    @{unique_errors}=    Create List
    ${js_error}=    Set Variable    JavaScript error
    FOR    ${line}    IN    @{new_lines}
        IF    $js_error in $line and $line not in $unique_errors
            Append To List    ${unique_errors}    ${line}
        END
    END

    RETURN    ${unique_errors}

Extract And Append Error
    [Documentation]    Splits the string at "," ->writes to a list, takes the first list entry and
    ...    removes all spaces from it
    [Arguments]    ${line}    ${error_list}

    ${lines}=    Split String    ${line}    ,
    ${error}=    Get From List    ${lines}    1
    ${error}=    Strip String    ${error}

    IF    $error not in $error_list
        Append To List    ${error_list}    ${error}
    END
