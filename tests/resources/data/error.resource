*** Settings ***
Documentation       Error Data Resource


*** Variables ***
&{ERROR_MAP}
# LOG IN
...             sorry, this user has been locked out= SELENIUM | Login failed: Sorry, this user is blocked
...             username and password do not match any user in this service= SELENIUM | Login Failed: Username and/or password incorrect
# PURCHASE
...             button with locator|finish= SELENIUM | Purchase failed - Finish button not available
...             page should have contained element|h2.complete-header= SELENIUM | Purchase failed - Finish button has no effect
...             cesetrart is not a function= JavaScript | Purchase failed - Finish button triggers non-existent function
...             totallyundefined is undefined= JavaScript | Occurred in purchase - Entry in lastname during checkout fails
