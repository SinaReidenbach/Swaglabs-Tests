*** Settings ***
Library     Process


*** Keywords ***
Save Purchase In Database
    [Documentation]    save actual data to database
    [Arguments]    ${user}    ${product_name}    ${price}

    Run Process
    ...    python
    ...    ../../../db/insert_purchase.py
    ...    ${user}    ${product_name}    ${price}
    ...    shell=True
    ...    cwd=${CURDIR}
