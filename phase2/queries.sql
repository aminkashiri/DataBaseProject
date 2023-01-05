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
EXCEPT
SELECT ticket.ticket_number, question.text AS question_text, choice.text AS choice_text
FROM ticket
         INNER JOIN flight ON ticket.flight_number = flight.flight_number
         INNER JOIN airline ON flight.airline_name = airline.name
         INNER JOIN manager ON airline.name = manager.airline_name
         INNER JOIN survey ON manager.username = survey.manager_username
         INNER JOIN question ON survey.id = question.survey_id
         FULL OUTER JOIN choice ON question.id = choice.question_id
         INNER JOIN validates ON question.id = validates.question_id
         INNER JOIN answers ON question.id = answers.question_id
WHERE ticket.ticket_number = ticket_num
  AND answers.ticket_number = ticket_num;

-- Query-2
SELECT answers.question_id, COUNT(answers.question_id)
FROM answers
         INNER JOIN choice ON answers.question_id = choice.question_id
         INNER JOIN question ON answers.question_id = question.id
         INNER JOIN survey ON answers.survey_id = survey.id
         INNER JOIN manager ON survey.manager_username = manager.username
         INNER JOIN complete ON survey.id = complete.survey_id
WHERE manager.username = manager_username
  AND question.type = 'MULTIPLE_CHOICE'
  AND answers.value = question.text
  AND from_time < complete.time
  AND to_time > complete.time
GROUP BY answers.question_id;

-- Query-3
SELECT answers.ticket_number, answers.question_id, answers.value
FROM answers
         INNER JOIN question ON answers.question_id = question.id
         INNER JOIN survey ON answers.survey_id = survey.id
         INNER JOIN manager ON survey.manager_username = manager.username
WHERE question.type = 'DESCRIPTIVE'
  AND manager.username = manager_username
  AND answers.value LIKE '%keyword';

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
