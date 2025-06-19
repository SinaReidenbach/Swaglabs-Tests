*** Settings ***
Resource            resources/keywords/auth_keywords.robot
Resource            resources/data/login_data.robot
Library             Collections

Suite Setup         Open Browser To Login Page
Suite Teardown      Close All Browsers

s
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
        FINALLY
            Logout
        END
    END
