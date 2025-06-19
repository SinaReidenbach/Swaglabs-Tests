*** Settings ***
Library     Process


*** Keywords ***
Save Purchase In Database
    [Arguments]    ${user}    ${product_name}    ${price}

    Run Process
    ...    python
    ...    ../../../db/insert_purchase.py
    ...    ${user}    ${product_name}    ${price}
    ...    shell=True
    ...    cwd=${CURDIR}
