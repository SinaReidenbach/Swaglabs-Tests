import mysql.connector
import sys

def convert_none_args(*args):
    return [None if arg == "None" else arg for arg in args]

def insert_purchase(testcase, username, product_name, price, result, error, error_description):
    print(f"Parameter erhalten: {testcase}, {username}, {product_name}, {price}, {result}, {error}, {error_description}")

    # Konvertiere "None" Strings zu echtem Python-None
    testcase, username, product_name, price, result, error, error_description = convert_none_args(
        testcase, username, product_name, price, result, error, error_description
    )
    connection = mysql.connector.connect(
        host="localhost",
        user="swaguser",
        password="swagpass",
        database="swaglabs",
        port=3306
    )
    cursor = connection.cursor()
    sql = "INSERT INTO purchases (testcase, username, product_name, price, result, error, error_description) VALUES (%s, %s, %s, %s, %s, %s, %s)"
    cursor.execute(sql, (testcase, username, product_name, price, result, error, error_description))

    connection.commit()
    cursor.close()
    connection.close()

if __name__ == "__main__":
    _,testcase, username, product_name, price, result, error, error_description = sys.argv

    insert_purchase(testcase, username, product_name, price, result, error, error_description)
