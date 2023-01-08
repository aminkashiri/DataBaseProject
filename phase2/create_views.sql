CREATE VIEW report as (
SELECT outer_airline.name, outer_survey.id,  outer_survey.start_time,  outer_survey.end_time, ( outer_survey.start_time < now() AND now() <  outer_survey.end_time),
    (
        SELECT COUNT(*)
        FROM survey
            INNER JOIN question on question.survey_id = survey.id
        WHERE question.type = 'DESCRIPTIVE'
            AND  outer_survey.id = survey.id
    ) descriptive_questions,
    (
        SELECT COUNT(*)
        FROM survey
            INNER JOIN question on question.survey_id = survey.id
        WHERE question.type = 'MULTIPLE_CHOICE'
            AND  outer_survey.id = survey.id
    ) multiple_choice_questions,
    (
        SELECT COUNT(*)
        FROM survey
            INNER JOIN complete on complete.survey_id = survey.id
        WHERE  outer_survey.id = survey.id
    ) total_answers,
    (SELECT COUNT(*)
        FROM ticket
            INNER JOIN flight on flight.flight_number = ticket.flight_number
            INNER JOIN airline on flight.airline_name = airline.name
        WHERE outer_airline.name = airline.name
            AND flight.date <  outer_survey.end_time) totalPossible,
    (
        (SELECT COUNT(*)
        FROM ticket
            INNER JOIN flight on flight.flight_number = ticket.flight_number
            INNER JOIN airline on flight.airline_name = airline.name
        WHERE outer_airline.name = airline.name
            AND flight.date <  outer_survey.end_time)
        -
        (
            SELECT COUNT(*)
            FROM survey
                INNER JOIN complete on complete.survey_id = survey.id
            WHERE  outer_survey.id = survey.id
        )
    ) not_answered

FROM survey outer_survey
    INNER JOIN manager on manager.username =  outer_survey.manager_username
    INNER JOIN airline outer_airline on outer_airline.name = manager.airline_name
)