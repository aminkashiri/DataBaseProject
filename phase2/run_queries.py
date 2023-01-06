import os
from query_executor import QueryExecutor

queries_path = "phase2/queries.sql"
queries = open(queries_path, "r").read().split(os.linesep*2)

def get_all_questions(ticket_number, passport_number):
    print('----------------------------- running query 1')
    query = queries[0].format(ticket_number=ticket_number)
    query_executor.execute_and_commit(query)
    # print(query_executor.fetchall())
    print('\n'.join(str(x) for x in query_executor.fetchall()))


if __name__ == "__main__":
    query_executor = QueryExecutor()
    get_all_questions(3, None)
