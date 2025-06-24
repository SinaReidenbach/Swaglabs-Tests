import mysql.connector
import sys

def create_purchase():
    connection = mysql.connector.connect(
        host="localhost",
        user="swaguser",
        password="swagpass",
        database="swaglabs",
        port=3306
    )
    cursor = connection.cursor()
    sql = (
        "CREATE TABLE IF NOT EXISTS purchases ("
            "id                 INT             AUTO_INCREMENT PRIMARY KEY, "
            "testcase           VARCHAR(50)     NOT NULL, "
            "username           VARCHAR(50)     NULL, "
            "product_name       VARCHAR(100)    NULL, "
            "price              DECIMAL(10,2)   NULL, "
            "error              LONGTEXT        NULL, "
            "error_description  LONGTEXT        NULL, "
            "purchase_date      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP"
        ");"
    )
    cursor.execute(sql)
    connection.commit()
    cursor.close()
    connection.close()

if __name__ == "__main__":
    create_purchase()
