import os
from query_executor import QueryExecutor

query_executor = QueryExecutor()
query_executor.execute_and_commit(open("phase2/triger.sql", "r").read())
print(query_executor.fetchall())
