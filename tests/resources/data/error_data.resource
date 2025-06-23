*** Variables ***
&{ERROR_MAP}
# LOG IN
...                         sorry, this user has been locked out= SEL: Login fehlgeschlagen: Sorry, dieser Nutzer ist gesperrt
...                         username and password do not match any user in this service= SEL: Login Fehlgeschlagen: Username und/oder Passwort falsch
# PURCHASE
...                         button with locator|finish= SEL: Kauf fehlgeschlagen - Finish-Button nicht vorhanden
...                         page should have contained element|h2.complete-header= SEL: Kauf fehlgeschlagen - Finish Button bewirkt nichts
...                         cesetrart is not a function= JS: Kauf fehlgeschlagen - Finish-Button löst nicht vorhandene Funktion aus
...                         totallyundefined is undefined= JS: In Kauf aufgetreten - Eintrag in Lastname beim Checkout schlägt Fehler
