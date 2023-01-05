import psycopg2

DB_CONFIG = {
    "dbname": "test_db",
    "user": "test_user",
    "password": "test_pass",
    "host": "localhost",
    "port": 1777,
}


class QueryExecutor:
    def __init__(self, db_config):
        self.conn = psycopg2.connect(
            dbname=db_config['dbname'],
            user=db_config['user'],
            password=db_config['password'],
            host=db_config['host'],
            port=db_config['port']
        )
        self.cursor = self.conn.cursor()
        print('PostgreSQL database version:')
        self.cursor.execute('SELECT version()')
        print(self.cursor.fetchone())

    def drop_everything(self):
        self.execute_and_commit("""
            DROP SCHEMA public CASCADE;
            CREATE SCHEMA public;
        """)

    def print_table(self, table_name):
        print(table_name)
        self.cursor.execute(f"SELECT * FROM {table_name};")
        for row in self.cursor.fetchall():
            print(row)

    def get_table_names(self):
        self.cursor.execute("""
            SELECT table_name FROM information_schema.tables
            WHERE table_schema = 'public'
        """)
        return self.cursor.fetchall()

    def print_all_tables(self):
        for table_name in self.get_table_names():
            self.print_table(table_name[0])

    def execute_and_commit(self, query):
        self.cursor.execute(query)
        self.conn.commit()

    def init_db(self, init_sql_path):
        self.cursor.execute(open(init_sql_path, 'r').read())
        self.conn.commit()


if __name__ == '__main__':
    query_executor = QueryExecutor(DB_CONFIG)
    query_executor.drop_everything()
    query_executor.init_db('init_postgres.sql')
    query_executor.print_all_tables()
