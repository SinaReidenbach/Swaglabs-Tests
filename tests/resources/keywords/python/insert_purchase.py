from robot.api.deco import keyword
import mysql.connector

def convert_none_args(*args):
    return [None if arg == "None" else arg for arg in args]

@keyword
def insert_purchase_to_db(testcase, username, product_name, price, result, error, error_description):
    print(f"Parameter erhalten: {testcase}, {username}, {product_name}, {price}, {result}, {error}, {error_description}")

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
    sql = """
    INSERT INTO purchases (testcase, username, product_name, price, result, error, error_description)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    cursor.execute(sql, (testcase, username, product_name, price, result, error, error_description))
    connection.commit()
    cursor.close()
    connection.close()
