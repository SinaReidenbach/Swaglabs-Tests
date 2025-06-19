*** Variables ***
&{ERROR_MAP_X}
...                         user-name|not found=❌ Login fehlgeschlagen: Eingabefeld für Benutzername nicht gefunden
...                         password|not found=❌ Login fehlgeschlagen: Passwortfeld nicht vorhanden
...                         login-button|not found=❌ Login fehlgeschlagen: Login-Button fehlt auf der Seite
...                         login-button|not clickable=❌ Login fehlgeschlagen: Login-Button nicht klickbar – möglicherweise überlagert
...                         react-burger-menu-btn|not found=❌ Logout nicht möglich: Menü-Button nicht vorhanden
...                         logout_sidebar_link|not found=❌ Logout nicht möglich: Logout-Link im Menü nicht sichtbar
...                         add-to-cart|not clickable=❌ Produkt konnte nicht in den Warenkorb gelegt werden: Button nicht klickbar
...                         timeout=❌ Aktion fehlgeschlagen: Timeout – Seite reagiert nicht
...                         element not interactable=❌ Aktion fehlgeschlagen: Element existiert, ist aber nicht bedienbar
...                         element not found=❌ Aktion fehlgeschlagen: Element wurde nicht gefunden
...                         error|last name=❌ Kauf fehlgeschlagen: Nachname wurde nicht eingetragen

&{ERROR_MAP_SELENIUM}
# LOG IN
...                         sorry, this user has been locked out=❌ Login fehlgeschlagen: Sorry, dieser Nutzer ist gesperrt
...                         username and password do not match any user in this service=❌ Login Fehlgeschlagen: Username und/oder Passwort falsch
# PURCHASE
...                         button with locator 'id|finish' not found=❌ Kauf fehlgeschlagen - Finish-Button nicht vorhanden
...                         page should have contained element|h2.complete-header=❌ Kauf fehlgeschlagen    # Fehlermeldung spezifizieren, ggf über abfangen von JS Fehler
# LOG OUT



# Abfangen von JS Fehlern im Browserlog:
# ${logs}=    Get Browser Logs
# Should Contain    ${logs}    Cannot read properties of undefined
# > Hinweis: Für Get Browser Logs benötigst du Chrome im Logging-Modus. Du kannst das mit einem benutzerdefinierten Create Webdriver-Setup aktivieren, wenn nötig.

# ...    Cannot read properties of undefined (reading 'value')=❌ Kauf fehlgeschlagen: Nachname kann nicht eingegeben werden    # JS Fehler, der seperat behandelt werden muss

# &{ERROR_MAP_JS}
# ...                         cannot read properties of undefined=❌ JavaScript-Fehler: Zugriff auf undefiniertes Objekt – möglicherweise fehlt ein Element oder Event-Handler
# ...                         unexpected token=❌ JavaScript-Fehler: Unerwartetes Zeichen – Syntaxfehler im JS-Code
# ...                         is not a function=❌ JavaScript-Fehler: Funktion nicht definiert oder falsch verwendet
# JS Fehler überarbeiten und neue suchen
