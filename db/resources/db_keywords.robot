*** Settings ***
Library     Process


*** Keywords ***
Speichere Kauf In Datenbank
    [Arguments]    ${username}    ${product_name}    ${price}
    Run Process    python3    ./db/insert_purchase.py    ${username}    ${product_name}    ${price}
    ...    shell=True    cwd=${CURDIR}
