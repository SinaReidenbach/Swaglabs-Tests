*** Variables ***
&{ERROR_MAP}
# LOG IN
...                         sorry, this user has been locked out= 🤖: Login fehlgeschlagen: Sorry, dieser Nutzer ist gesperrt
...                         username and password do not match any user in this service= 🤖: Login Fehlgeschlagen: Username und/oder Passwort falsch
# PURCHASE
...                         button with locator|finish= 🤖: Kauf fehlgeschlagen - Finish-Button nicht vorhanden
...                         page should have contained element|h2.complete-header= 🤖: Kauf fehlgeschlagen - Finish Button bewirkt nichts
...                         cesetrart is not a function= 📜: Kauf fehlgeschlagen - Finish-Button löst nicht vorhandene Funktion aus
...                         totallyundefined is undefined= 📜: In Kauf aufgetreten - Eintrag in Lastname beim Checkout schlägt Fehler
