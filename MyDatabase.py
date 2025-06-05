import pymysql

class MyDatabase:
    def __init__(self):
        self.connection = None

    def connect_to_database(self, host, port, dbname, user, password):
        self.connection = pymysql.connect(
            host=host,
            port=int(port),
            user=user,
            password=password,
            database=dbname,
            cursorclass=pymysql.cursors.DictCursor
        )

    def execute_sql(self, sql_query):
        if self.connection is None:
            raise Exception("Database connection is not established")
        with self.connection.cursor() as cursor:
            cursor.execute(sql_query)
            self.connection.commit()

    def disconnect_from_database(self):
        if self.connection:
            self.connection.close()
            self.connection = None
