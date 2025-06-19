*** Settings ***
Resource            resources/keywords/auth_keywords.robot

Suite Setup         Open Browser To Login Page
Suite Teardown      Close Browser

*** Test Cases ***
Test Login And Logout With All Users
    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        TRY
            Log    Aktueller Testnutzer: ${user}
            Login With Valid Credentials    ${user}    ${password}
        EXCEPT    AS    ${error}
            #ToDo: Fehler in die DB übertragen
            Log   ${user} : ${error}
            CONTINUE
        END
        TRY
            Logout
        EXCEPT    AS    ${error}
            #ToDo: Fehler in die DB übertragen
            Log   ${user} : ${error}
            CONTINUE
        END
    END
