import os
from query_executor import QueryExecutor

queries_path = "phase2/queries.sql"
queries = open(queries_path, "r").read().split(os.linesep * 2)


def get_all_questions(ticket_number, passport_number):
    print("----------------------------- running query 1")
    query = queries[0].format(ticket_number=ticket_number)
    query_executor.execute_and_commit(query)
    print("\n".join(str(x) for x in query_executor.fetchall()))


def get_choice_counts(manager_username, from_time, to_time):
    print("----------------------------- running query 2")
    query = queries[1].format(
        manager_username=manager_username, from_time=from_time, to_time=to_time
    )
    query_executor.execute_and_commit(query)
    print("\n".join(str(x) for x in query_executor.fetchall()))


def get_answers_like(manager_username, keyword):
    print("----------------------------- running query 3")
    query = queries[2].format(manager_username=manager_username, keyword=keyword)
    query_executor.execute_and_commit(query)
    print("\n".join(str(x) for x in query_executor.fetchall()))


def get_mean_of_each_class(manager_username):
    print("----------------------------- running query 4")
    query = queries[3].format(manager_username=manager_username)
    query_executor.execute_and_commit(query)
    print("\n".join(str(x) for x in query_executor.fetchall()))


def get_non_validated_questions():
    print("----------------------------- running query 5")
    query = queries[4].format()
    query_executor.execute_and_commit(query)
    print("\n".join(str(x) for x in query_executor.fetchall()))


def get_total_participants():
    print("----------------------------- running query 6")
    query = queries[5].format()
    print(query)
    query_executor.execute_and_commit(query)
    print("\n".join(str(x) for x in query_executor.fetchall()))



if __name__ == "__main__":
    query_executor = QueryExecutor()
    # get_all_questions(3, None)

    # get_choice_counts(
    #     "'iran-air-mng'",
    #     "to_timestamp('21 Dec 2020', 'DD Mon YYYY')",
    #     "to_timestamp('21 Dec 2030', 'DD Mon YYYY')",
    # )

    # get_answers_like("'iran-air-mng'", "Pi")

    # get_mean_of_each_class("'iran-air-mng'")

    # get_non_validated_questions()

    get_total_participants()
