CREATE TYPE GENDER_TYPE AS
    ENUM ('MALE', 'FEMALE');

CREATE TYPE FLIGHT_CLASS AS
    ENUM ('BUSINESS', 'ECONOMY');

CREATE TYPE QUESTION_TYPE AS
    ENUM('DESCRIPTIVE', 'MULTIPLE_CHOICE');

CREATE TABLE airline
(
    name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE manager
(
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    airline_name  VARCHAR(50) NOT NULL,
    FOREIGN KEY (airline_name)
        REFERENCES airline (name)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE supervisor
(
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL
);

CREATE TABLE survey
(
    id                  INT PRIMARY KEY,
    manager_username    VARCHAR(50) NOT NULL,
    start_time          TIMESTAMP,
    end_time            TIMESTAMP check (start_time < end_time),
    FOREIGN KEY (manager_username)
        REFERENCES manager (username)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE assistant
(
    manager_username     VARCHAR(50) NOT NULL,
    assistant_username    VARCHAR(50) NOT NULL,
    survey_id      INT NOT NULL,
    CONSTRAINT assitant_pkey
        PRIMARY KEY (manager_username, assistant_username, survey_id),
    FOREIGN KEY (manager_username)
        REFERENCES manager (username)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (assistant_username)
        REFERENCES manager (username)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (survey_id)
        REFERENCES survey (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE flight
(
    flight_number   INT PRIMARY KEY,
    airline_name    VARCHAR(50) NOT NULL,
    date            TIMESTAMP,
    FOREIGN KEY (airline_name)
        REFERENCES airline (name)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE ticket
(
    ticket_number   INT PRIMARY KEY,
    name            VARCHAR(50),
    family          VARCHAR(50),
    passport_number INT,
    flight_number   INT NOT NULL,
    date            TIMESTAMP,
    seat_number     INT,
    gender          GENDER_TYPE,
    price           INT check (price > 0),
    FOREIGN KEY (flight_number)
        REFERENCES flight (flight_number)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE complete
(
    ticket_number INT,
    survey_id     INT,
    time          TIMESTAMP,
    CONSTRAINT complete_pkey
        PRIMARY KEY (ticket_number, survey_id),
    FOREIGN KEY (ticket_number)
        REFERENCES ticket (ticket_number)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (survey_id)
        REFERENCES survey (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE question
(
    id           INT PRIMARY KEY,
    survey_id    INT NOT NULL,
    text         VARCHAR(500),
    class        FLIGHT_CLASS  NOT NULL,
    is_mandatory BOOLEAN DEFAULT False,
    type         QUESTION_TYPE NOT NULL,
    FOREIGN KEY (survey_id)
        REFERENCES survey (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE answers
(
    ticket_number   INT,
    survey_id       INT,
    question_id     INT,
    value           VARCHAR(500),
    CONSTRAINT answers_pk
        PRIMARY KEY (ticket_number, survey_id, question_id),
    FOREIGN KEY (ticket_number)
        REFERENCES ticket (ticket_number)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (survey_id)
        REFERENCES survey (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (question_id)
        REFERENCES question (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Constraint on the minimum number of choices for a question needs trigger
CREATE TABLE choice
(
    question_id INT,
    text VARCHAR(50),
    CONSTRAINT choice_pk
        PRIMARY KEY (question_id, text),
    FOREIGN KEY (question_id)
        REFERENCES question (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
;

CREATE TABLE validates
(
    question_id         INT,
    supervisor_username VARCHAR(50),
    CONSTRAINT validates_pkey
        PRIMARY KEY (question_id, supervisor_username),
    FOREIGN KEY (question_id)
        REFERENCES question (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (supervisor_username)
        REFERENCES supervisor (username)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
