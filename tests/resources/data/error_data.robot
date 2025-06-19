*** Variables ***
&{ERROR_MAP_SELENIUM}
# LOG IN
...                         sorry, this user has been locked out=❌ Login fehlgeschlagen: Sorry, dieser Nutzer ist gesperrt
...                         username and password do not match any user in this service=❌ Login Fehlgeschlagen: Username und/oder Passwort falsch
# PURCHASE
...                         button with locator 'id|finish' not found=❌ Kauf fehlgeschlagen - Finish-Button nicht vorhanden
...                         page should have contained element|h2.complete-header=❌ Kauf fehlgeschlagen - Finish Button bewirkt nichts
# LOG OUT

# Abfangen von JS Fehlern im Browserlog:
# ${logs}=    Get Browser Logs
# Should Contain    ${logs}    Cannot read properties of undefined
# > Hinweis: Für Get Browser Logs benötigst du Chrome im Logging-Modus. Du kannst das mit einem benutzerdefinierten Create Webdriver-Setup aktivieren, wenn nötig.

# ...    Cannot read properties of undefined (reading 'value')=❌ Kauf fehlgeschlagen: Nachname kann nicht eingegeben werden    # JS Fehler, der seperat behandelt werden muss

# &{ERROR_MAP_JS}
# ...    cannot read properties of undefined=❌ JavaScript-Fehler: Zugriff auf undefiniertes Objekt – möglicherweise fehlt ein Element oder Event-Handler
# ...    unexpected token=❌ JavaScript-Fehler: Unerwartetes Zeichen – Syntaxfehler im JS-Code
# ...    is not a function=❌ JavaScript-Fehler: Funktion nicht definiert oder falsch verwendet
# JS Fehler überarbeiten und neue suchen
