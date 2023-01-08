import psycopg2
from dotenv import dotenv_values

config = dotenv_values(".env")
DB_CONFIG = {
    "dbname": config["DB_POSTGRESQL_NAME"],
    "user": config["DB_POSTGRESQL_USER"],
    "password": config["DB_POSTGRESQL_PASS"],
    "host": config["DB_POSTGRESQL_HOST"],
    "port": config["DB_POSTGRESQL_PORT"],
}


class QueryExecutor:
    def __init__(self):
        self.conn = psycopg2.connect(**DB_CONFIG)
        self.cursor = self.conn.cursor()
        print("PostgreSQL database version:")
        self.cursor.execute("SELECT version()")
        print(self.cursor.fetchone())

    def drop_everything(self):
        self.execute_and_commit(
            """
            DROP SCHEMA public CASCADE;
            CREATE SCHEMA public;
        """
        )

    def print_table(self, table_name):
        print(table_name)
        self.cursor.execute(f"SELECT * FROM {table_name};")
        for row in self.cursor.fetchall():
            print(row)

    def get_table_names(self):
        self.cursor.execute(
            """
            SELECT table_name FROM information_schema.tables
            WHERE table_schema = 'public'
        """
        )
        return self

    def print_all_tables(self):
        for table_name in self.get_table_names().fetchall():
            self.print_table(table_name[0])
        return self

    def execute_and_commit(self, query):
        self.cursor.execute(query)
        self.conn.commit()
        return self

    def init_db(self, init_sql_path):
        self.cursor.execute(open(init_sql_path, "r").read())
        self.conn.commit()
        return self

    def fetchone(self):
        return self.cursor.fetchone()

    def fetchall(self):
        return self.cursor.fetchall()
