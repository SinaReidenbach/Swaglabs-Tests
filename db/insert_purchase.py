import mysql.connector
import sys

def insert_purchase(username, product_name, price, error, error_describtion):
    connection = mysql.connector.connect(
        host="localhost",
        user="swaguser",
        password="swagpass",
        database="swaglabs",
        port=3306
    )
    cursor = connection.cursor()
    sql = "INSERT INTO purchases (username, product_name, price, error, error_describtion) VALUES (%s, %s, %s, %s, %s)"
    cursor.execute(sql, (username, product_name, price, error, error_describtion))
    connection.commit()
    cursor.close()
    connection.close()

if __name__ == "__main__":
    insert_purchase(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
