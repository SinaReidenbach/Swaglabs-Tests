import mysql.connector
from mysql.connector import Error

try:
    conn = mysql.connector.connect(
        host="localhost",
        user="swaguser",
        password="swagpass",
        database="swaglabs",
        port=3306
    )
    if conn.is_connected():
        print("OK")
except Error as e:
    print(f"ERROR: {e}")
    exit(1)
finally:
    if 'conn' in locals() and conn.is_connected():
        conn.close()
