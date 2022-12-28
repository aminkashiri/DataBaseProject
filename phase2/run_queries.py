import psycopg2

conn = psycopg2.connect(dbname="test_db", user="test_user", password="test_pass", host="localhost", port=1777)

cursor = conn.cursor()
        
# execute a statement
print('PostgreSQL database version:')
cursor.execute('SELECT version()')
print(cursor.fetchone())

DROP_EVERYTHING = """
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
"""
cursor.execute(DROP_EVERYTHING)
conn.commit()



LIST_TABLES = """
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
"""
cursor.execute(LIST_TABLES)
for table in cursor.fetchall():
    print(table)


cursor.execute(open("phase2/init_postgres.sql", "r").read())

cursor.execute(LIST_TABLES)
for table in cursor.fetchall():
    print(table)
