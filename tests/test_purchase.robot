*** Settings ***
Resource            resources/keywords/purchase_keywords.robot

Suite Setup         Open Browser To Login Page
Suite Teardown      Close Browser

*** Test Cases ***
Purchase With All Users
    FOR    ${user}    ${password}    IN    &{ACCOUNTS}
        TRY
            Login With Valid Credentials    ${user}    ${password}
        EXCEPT
            CONTINUE
        END

        Log    Aktueller Testnutzer: ${user}
        TRY
            Add Item And Go To Cart
            ${product_name}    ${price}=    Get Product Info    ${user}
            Checkout
            Finish And Save    ${user}    ${product_name}    ${price}
        EXCEPT    AS    ${error}
            #ToDo: Fehler in die DB übertragen
            Log   ${user} : ${error}
            CONTINUE
        FINALLY
            Run Keyword And Ignore Error    Logout
        END
    END
