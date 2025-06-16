*** Settings ***
Library     Process


*** Keywords ***
Save Purchase In Database
    [Arguments]    ${username}    ${product_name}    ${price}

    Run Process    python    ../../db/insert_purchase.py    ${username}    ${product_name}    ${price}
    ...    shell=True    cwd=${CURDIR}
