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
            "id            INT           AUTO_INCREMENT PRIMARY KEY, "
            "username      VARCHAR(50)   NOT NULL, "
            "product_name  VARCHAR(100)  NOT NULL, "
            "price         DECIMAL(10,2) NOT NULL, "
            "error  VARCHAR(100)  NOT NULL, "
            "error_description  VARCHAR(100)  NOT NULL, "
            "purchase_date TIMESTAMP     DEFAULT CURRENT_TIMESTAMP"
        ");"
    )
    cursor.execute(sql)
    connection.commit()
    cursor.close()
    connection.close()

if __name__ == "__main__":
    create_purchase()
