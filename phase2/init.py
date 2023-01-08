from query_executor import QueryExecutor


if __name__ == "__main__":
    query_executor = QueryExecutor()
    query_executor.drop_everything()
    query_executor.init_db("phase2/init_postgres.sql")
    query_executor.print_all_tables()
