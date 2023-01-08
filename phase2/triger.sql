DROP TRIGGER IF EXISTS valid_time_check
ON survey;

CREATE  or replace FUNCTION check_time()
  RETURNS trigger AS
$func$
BEGIN
    IF (NEW.end_time) < now() THEN
      RETURN NULL;
    END IF;

    IF EXISTS (SELECT start_time, end_time from survey
                WHERE ((NEW.start_time > start_time AND NEW.start_time < end_time)
                  OR  (NEW.end_time > start_time AND NEW.end_time < end_time))
                ) THEN
      RETURN NULL;
    END IF;
  RETURN NEW;
END
$func$  LANGUAGE plpgsql;

CREATE trigger valid_time_check before insert or update on survey for each row execute procedure check_time();

INSERT INTO survey (id, manager_username, start_time, end_time)
VALUES (7, 'iran-air-mng', to_timestamp('21 Dec 2022', 'DD Mon YYYY'), to_timestamp('26 Dec 2024', 'DD Mon YYYY')),
       (8, 'iran-air-mng', to_timestamp('21 Dec 2022', 'DD Mon YYYY'), to_timestamp('26 Dec 2022', 'DD Mon YYYY'));

UPDATE survey SET start_time = to_timestamp('21 Dec 2019', 'DD Mon YYYY'), end_time = to_timestamp('21 Dec 2020','DD Mon YYYY')
       WHERE id = 1;
UPDATE survey SET start_time = to_timestamp('21 Dec 2022', 'DD Mon YYYY'), end_time = to_timestamp('21 Dec 2023','DD Mon YYYY')
       WHERE id = 2;

SELECT * FROM survey;