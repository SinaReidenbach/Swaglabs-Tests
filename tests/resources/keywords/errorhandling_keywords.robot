*** Settings ***
Library     Collections
Library     String
Library     SeleniumLibrary
Resource    util_keywords.robot
Resource    ../data/login_data.robot
Resource    ../data/error_data.robot


*** Keywords ***
Error Message
    [Documentation]    convert selenium-errors to understandable error-messages
    [Arguments]    ${user}    ${error}

    ${message_lower}=
    ...    Convert To Lowercase
    ...    ${error}

    VAR
    ...    ${mapped_message}=
    ...    ${user} :: ${error}

    FOR    ${key}    ${msg}    IN    &{ERROR_MAP_SELENIUM}
        @{parts}=
        ...    Split String
        ...    ${key}    |

        VAR
        ...    ${found}=
        ...    True

        FOR    ${part}    IN    @{parts}
            IF    $part not in "${message_lower}"
                VAR
                ...    ${found}=
                ...    False

                BREAK
            END
        END

        IF    '${found}' == 'True'
            VAR
            ...    ${mapped_message}=
            ...    ${user} : ${msg}

            BREAK
        END
    END

    Log
    ...    ${mapped_message}
    ...    \n
