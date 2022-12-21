CREATE TYPE GENDER_TYPE AS
    ENUM ('MALE', 'FEMALE');

CREATE TYPE FLIGHT_CLASS AS
    ENUM ('BUSINESS', 'ECONOMY');

CREATE TYPE QUESTION_TYPE AS
    ENUM('DESCRIPTIVE', 'MULTIPLE_CHOICE');

CREATE TABLE airline
(
    name VARCHAR(50) PRIMARY KEY,
);

CREATE TABLE manager
(
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL,
    airline  VARCHAR(50),
    CONSTRAINT fk_airline
        FOREIGN KEY (airline)
            REFERENCES airline (name)
            ON DELETE SET NULL
);

CREATE TABLE supervisor
(
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(50) NOT NULL
);

CREATE TABLE survey
(
    s_id       INT PRIMARY KEY,
    m_username VARCHAR(50),
    start      TIMESTAMP,
    end        TIMESTAMP,
    CONSTRAINT fk_m_username
        FOREIGN KEY (m_username)
            REFERENCES manager (username)
            ON DELETE SET NULL
);

CREATE TABLE assistant
(
    m_username VARCHAR(50),
    a_username VARCHAR(50),
    s_id       INT,
    CONSTRAINT fk_m_username
        FOREIGN KEY (m_username)
            REFERENCES manager (username)
            ON DELETE SET NULL,
    CONSTRAINT fk_s_id
        FOREIGN KEY (s_id)
            REFERENCES survey (s_id)
            ON DELETE SET NULL,
);

CREATE TABLE flight
(
    flight_number INT PRIMARY KEY,
    airline       VARCHAR(50),
    date          TIMESTAMP,
    CONSTRAINT fk_airline
        FOREIGN KEY (name)
            REFERENCES airline (name)
            ON DELETE CASCADE
);

CREATE TABLE ticket
(
    ticket_number   INT PRIMARY KEY,
    name            VARCHAR(50),
    family          VARCHAR(50),
    passport_number INT,
    flight_number   INT,
    date            TIMESTAMP,
    seat_number     INT,
    gender          GENDER_TYPE,
    price           INT,
    CONSTRAINT fk_flight_number
        FOREIGN KEY (flight_number)
            REFERENCES flight (flight_number)
            ON DELETE CASCADE
);

CREATE TABLE complete
(
    ticket_number INT,
    s_id          INT,
    time          TIMESTAMP,
    CONSTRAINT fk_ticket_number
        FOREIGN KEY (ticket_number)
            REFERENCES ticket (ticket_number)
            ON DELETE CASCADE,
    CONSTRAINT fk_s_id
        FOREIGN KEY (s_id)
            REFERENCES survey (s_id)
            ON DELETE CASCADE
);

CREATE TABLE question
(
    q_id         INT PRIMARY KEY,
    s_id         INT,
    text         VARCHAR(500),
    class        FLIGHT_CLASS  NOT NULL,
    is_mandatory BOOLEAN,
    type         QUESTION_TYPE NOT NULL,
    CONSTRAINT fk_s_id
        FOREIGN KEY (s_id)
            REFERENCES survey (s_id)
            ON DELETE CASCADE
);

CREATE TABLE answers
(
    ticket_number INT,
    s_id          INT,
    q_id          INT,
    value         VARCHAR(500),
    CONSTRAINT fk_ticket_number
        FOREIGN KEY (ticket_number)
            REFERENCES ticket (ticket_number)
            ON DELETE CASCADE,
    CONSTRAINT fk_s_id
        FOREIGN KEY (s_id)
            REFERENCES survey (s_id)
            ON DELETE CASCADE,
    CONSTRAINT fk_q_id
        FOREIGN KEY (q_id)
            REFERENCES question (q_idq)
            ON DELETE CASCADE
);

CREATE TABLE choice
(
    q_id INT,
    text VARCHAR(500),
    CONSTRAINT fk_q_id
        FOREIGN KEY (q_id)
            REFERENCES question (q_idq)
            ON DELETE CASCADE
);

CREATE TABLE validated
(
    q_id       INT,
    s_username VARCHAR(50),
    CONSTRAINT fk_q_id
        FOREIGN KEY (q_id)
            REFERENCES question (q_idq)
            ON DELETE CASCADE,
    CONSTRAINT fk_username
        FOREIGN KEY (s_username)
            REFERENCES supervisor (username)
);
