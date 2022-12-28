CREATE TYPE GENDER_TYPE AS
    ENUM ('MALE', 'FEMALE');

CREATE TYPE FLIGHT_CLASS AS
    ENUM ('BUSINESS', 'ECONOMY');

CREATE TYPE QUESTION_TYPE AS
    ENUM('DESCRIPTIVE', 'MULTIPLE_CHOICE');

CREATE TABLE airline
(
    name VARCHAR(50),
    CONSTRAINT pk_name
        PRIMARY KEY (name)
);

CREATE TABLE manager
(
    username VARCHAR(50),
    password VARCHAR(50) NOT NULL,
    airline  VARCHAR(50),
    CONSTRAINT pk_username
        PRIMARY KEY (username),
    CONSTRAINT fk_airline
        FOREIGN KEY (airline)
            REFERENCES airline (name)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE supervisor
(
    username VARCHAR(50),
    password VARCHAR(50) NOT NULL,
    CONSTRAINT pk_username
        PRIMARY KEY (username)
);

CREATE TABLE survey
(
    s_id       INT,
    m_username VARCHAR(50),
    start_time      TIMESTAMP,
    end_time        TIMESTAMP,
    CONSTRAINT pk_s_id
        PRIMARY KEY (s_id),
    CONSTRAINT fk_m_username
        FOREIGN KEY (m_username)
            REFERENCES manager (username)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE assistant
(
    m_username VARCHAR(50),
    a_username VARCHAR(50),
    s_id       INT,
    CONSTRAINT pk_m_username_a_username_s_id
        PRIMARY KEY (m_username, a_username, s_id),
    CONSTRAINT fk_m_username
        FOREIGN KEY (m_username)
            REFERENCES manager (username)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT fk_a_username
        FOREIGN KEY (a_username)
            REFERENCES manager (username)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT fk_s_id
        FOREIGN KEY (s_id)
            REFERENCES survey (s_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE flight
(
    flight_number INT,
    airline       VARCHAR(50),
    date          TIMESTAMP,
    CONSTRAINT pk_flight_number
        PRIMARY KEY (flight_number),
    CONSTRAINT fk_airline
        FOREIGN KEY (name)
            REFERENCES airline (name)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE ticket
(
    ticket_number   INT,
    name            VARCHAR(50),
    family          VARCHAR(50),
    passport_number INT,
    flight_number   INT,
    date            TIMESTAMP,
    seat_number     INT,
    gender          GENDER_TYPE,
    price           INT,
    CONSTRAINT pk_ticket_number
        PRIMARY KEY (ticket_number),
    CONSTRAINT fk_flight_number
        FOREIGN KEY (flight_number)
            REFERENCES flight (flight_number)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE complete
(
    ticket_number INT,
    s_id          INT,
    time          TIMESTAMP,
    CONSTRAINT pk_ticket_number_s_id
        PRIMARY KEY (ticket_number, s_id),
    CONSTRAINT fk_ticket_number
        FOREIGN KEY (ticket_number)
            REFERENCES ticket (ticket_number)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT fk_s_id
        FOREIGN KEY (s_id)
            REFERENCES survey (s_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE question
(
    q_id         INT,
    s_id         INT,
    text         VARCHAR(500),
    class        FLIGHT_CLASS  NOT NULL,
    is_mandatory BOOLEAN,
    type         QUESTION_TYPE NOT NULL,
    CONSTRAINT pk_q_id
        PRIMARY KEY (q_id),
    CONSTRAINT fk_s_id
        FOREIGN KEY (s_id)
            REFERENCES survey (s_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE answers
(
    ticket_number INT,
    s_id          INT,
    q_id          INT,
    value         VARCHAR(500),
    CONSTRAINT pk_ticket_number_s_id_q_id
        PRIMARY KEY (ticket_number, s_id, q_id),
    CONSTRAINT fk_ticket_number
        FOREIGN KEY (ticket_number)
            REFERENCES ticket (ticket_number)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT fk_s_id
        FOREIGN KEY (s_id)
            REFERENCES survey (s_id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT fk_q_id
        FOREIGN KEY (q_id)
            REFERENCES question (q_idq)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE choice
(
    q_id INT,
    text VARCHAR(500),
    CONSTRAINT pk_q_id_text
        PRIMARY KEY (q_id, text),
    CONSTRAINT fk_q_id
        FOREIGN KEY (q_id)
            REFERENCES question (q_idq)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE validated
(
    q_id       INT,
    s_username VARCHAR(50),
    CONSTRAINT pk_q_id_s_username
        PRIMARY KEY (q_id, s_username),
    CONSTRAINT fk_q_id
        FOREIGN KEY (q_id)
            REFERENCES question (q_idq)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT fk_s_username
        FOREIGN KEY (s_username)
            REFERENCES supervisor (username)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);
