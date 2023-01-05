-- Query-1
SELECT ticket.ticket_number, question.text AS question_text, choice.text AS choice_text
FROM ticket
         INNER JOIN flight ON ticket.flight_number = flight.flight_number
         INNER JOIN airline ON flight.airline_name = airline.name
         INNER JOIN manager ON airline.name = manager.airline_name
         INNER JOIN survey ON manager.username = survey.manager_username
         INNER JOIN question ON survey.id = question.survey_id
         FULL OUTER JOIN choice ON question.id = choice.question_id
         INNER JOIN validates ON question.id = validates.question_id
WHERE ticket.ticket_number = ticket_num
  AND now() > survey.start_time
  AND now() < survey.end_time
  AND question.class = ticket.class
ORDER BY ticket.ticket_number;

-- Query-2

-- Query-3

-- Query-4

-- Query-5
SELECT q.id, q.text
FROM question AS q
EXCEPT
SELECT v.question_id, q.text
FROM question AS q,
     validates AS v
WHERE q.id = v.question_id;

-- Query-6

-- Query-7
