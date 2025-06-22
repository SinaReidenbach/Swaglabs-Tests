# robocop: off=line-too-long
*** Variables ***
&{ERROR_MAP}
# LOG IN
...                         sorry, this user has been locked out=❌ Selenium Fehler: Login fehlgeschlagen: Sorry, dieser Nutzer ist gesperrt
...                         username and password do not match any user in this service=❌ Selenium Fehler: Login Fehlgeschlagen: Username und/oder Passwort falsch
# PURCHASE
...                         button with locator|finish=❌ Selenium Fehler: Kauf fehlgeschlagen - Finish-Button nicht vorhanden
...                         page should have contained element|h2.complete-header=❌ Selenium Fehler: Kauf fehlgeschlagen - Finish Button bewirkt nichts
...                         cesetrart is not a function=❌ JavaScript-Fehler: Finish-Button löst nicht vorhandene Funktion aus
# LOG OUT
