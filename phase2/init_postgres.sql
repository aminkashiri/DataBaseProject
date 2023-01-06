-- Create enums for needed data types
CREATE TYPE GENDER_TYPE AS
    ENUM ('MALE', 'FEMALE');

CREATE TYPE FLIGHT_CLASS AS
    ENUM ('BUSINESS', 'ECONOMY');

CREATE TYPE QUESTION_TYPE AS
    ENUM('DESCRIPTIVE', 'MULTIPLE_CHOICE');

-- Create tables
CREATE TABLE airline
(
    name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE manager
(
    username     VARCHAR(50) PRIMARY KEY,
    password     VARCHAR(50) NOT NULL,
    airline_name VARCHAR(50) NOT NULL,
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
    id               INT PRIMARY KEY,
    manager_username VARCHAR(50) NOT NULL,
    start_time       TIMESTAMP,
    end_time         TIMESTAMP check (start_time < end_time),
    FOREIGN KEY (manager_username)
        REFERENCES manager (username)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE assistant
(
    manager_username   VARCHAR(50) NOT NULL,
    assistant_username VARCHAR(50) NOT NULL,
    survey_id          INT         NOT NULL,
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
    flight_number INT PRIMARY KEY,
    airline_name  VARCHAR(50) NOT NULL,
    date          TIMESTAMP,
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
    passport_number BIGINT,
    flight_number   INT NOT NULL,
    date            TIMESTAMP,
    seat_number     INT,
    class           FLIGHT_CLASS  NOT NULL,
    gender          GENDER_TYPE,
    price           BIGINT check (price > 0),
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
    survey_id    INT           NOT NULL,
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
    ticket_number INT,
    question_id   INT,
    value         VARCHAR(500),
    CONSTRAINT answers_pk
        PRIMARY KEY (ticket_number, question_id),
    FOREIGN KEY (ticket_number)
        REFERENCES ticket (ticket_number)
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
    text        VARCHAR(50),
    CONSTRAINT choice_pk
        PRIMARY KEY (question_id, text),
    FOREIGN KEY (question_id)
        REFERENCES question (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

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

-- Insert sample data into tables
INSERT INTO airline (name)
VALUES ('iran-air'),
       ('mahan'),
       ('taban');

INSERT INTO manager (username, password, airline_name)
VALUES ('iran-air-mng', 'mng-pass', 'iran-air'),
       ('mahan-mng', 'mng-pass', 'mahan'),
       ('taban-mng', 'mng-pass', 'taban');

INSERT INTO supervisor (username, password)
VALUES ('supervisor-1', 'sup-pass'),
       ('supervisor-2', 'sup-pass');

INSERT INTO survey (id, manager_username, start_time, end_time)
VALUES (1, 'iran-air-mng', to_timestamp('05 Dec 2022', 'DD Mon YYYY'), to_timestamp('20 Dec 2022', 'DD Mon YYYY')),
       (2, 'mahan-mng', to_timestamp('01 Dec 2022', 'DD Mon YYYY'), to_timestamp('20 Dec 2022', 'DD Mon YYYY')),
       (3, 'iran-air-mng', to_timestamp('21 Dec 2022', 'DD Mon YYYY'), to_timestamp('19 Jan 2023', 'DD Mon YYYY')),
       (4, 'mahan-mng', to_timestamp('21 Dec 2022', 'DD Mon YYYY'), to_timestamp('01 Jan 2023', 'DD Mon YYYY'));

INSERT INTO assistant (manager_username, assistant_username, survey_id)
VALUES ('mahan-mng', 'taban-mng', 2),
       ('iran-air-mng', 'taban-mng', 1),
       ('iran-air-mng', 'mahan-mng', 1);

INSERT INTO flight (flight_number, airline_name, "date")
VALUES (1, 'iran-air', to_timestamp('23 Nov 2022', 'DD Mon YYYY')),
       (2, 'mahan', to_timestamp('18 Dec 2022', 'DD Mon YYYY')),
       (3, 'mahan', to_timestamp('18 Dec 2022', 'DD Mon YYYY')),
       (4, 'mahan', to_timestamp('18 Dec 2022', 'DD Mon YYYY')),
       (5, 'mahan', to_timestamp('18 Dec 2022', 'DD Mon YYYY')),
       (6, 'taban', to_timestamp('21 Nov 2022', 'DD Mon YYYY'));

INSERT INTO ticket (ticket_number, name, family, passport_number, flight_number, "date", seat_number, class, gender, price)
VALUES (1, 'Norean', 'Kibel', '5085999096', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 42, 'ECONOMY', 'FEMALE', 4428588),
       (2, 'Marcos', 'Spera', '7847067439', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 39, 'ECONOMY', 'FEMALE', 4614771),
       (3, 'Raddie', 'Storie', '3072111383', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 10, 'ECONOMY', 'FEMALE', 4592103),
       (4, 'Towney', 'Fussell', '4528681412', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 19, 'BUSINESS', 'FEMALE', 3343923),
       (5, 'Lynnea', 'Gibling', '7535744168', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 27, 'ECONOMY', 'FEMALE', 4612002),
       (6, 'Rriocard', 'Rosi', '0639477283', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 79, 'ECONOMY', 'FEMALE', 2648069),
       (7, 'Doyle', 'Rainard', '3356849573', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 28, 'ECONOMY', 'FEMALE', 1520940),
       (8, 'Paige', 'Cosely', '8663180632', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 90, 'ECONOMY', 'FEMALE', 1200678),
       (9, 'Huey', 'Boddice', '6341946406', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 16, 'ECONOMY', 'FEMALE', 1343831),
       (10, 'Audry', 'Gawne', '3243789095', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 34, 'ECONOMY', 'FEMALE', 1500376),
       (11, 'Stormie', 'Aldous', '9776889379', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 52, 'ECONOMY', 'FEMALE', 3615160),
       (12, 'Booth', 'Bradden', '3879340145', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 53, 'ECONOMY', 'FEMALE', 4647523),
       (13, 'Park', 'Caudle', '8324837108', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 2, 'ECONOMY', 'FEMALE', 1255162),
       (14, 'Marie', 'Leahy', '7370021610', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 50, 'ECONOMY', 'FEMALE', 4845176),
       (15, 'Murvyn', 'Raise', '5623046053', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 54, 'ECONOMY', 'FEMALE', 3004433),
       (16, 'Rhody', 'Loveredge', '6885311618', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 68, 'ECONOMY', 'FEMALE', 2136070),
       (17, 'Emogene', 'Gauche', '3930946726', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 71, 'ECONOMY', 'FEMALE', 3222515),
       (18, 'Dahlia', 'Oiller', '4035488305', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 37, 'ECONOMY', 'FEMALE', 2995396),
       (19, 'Menard', 'Vaar', '6030367927', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 75, 'ECONOMY', 'FEMALE', 1934083),
       (20, 'Cymbre', 'Jerred', '8322636954', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 30, 'ECONOMY', 'FEMALE', 1622875),
       (21, 'Emerson', 'Sherme', '2090386509', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 44, 'ECONOMY', 'FEMALE', 2132506),
       (22, 'Bev', 'Bogeys', '7780381943', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 49, 'ECONOMY', 'FEMALE', 1592294),
       (23, 'Brenda', 'Stilliard', '9628250256', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 44, 'ECONOMY', 'FEMALE', 4049810),
       (24, 'Bev', 'Smalles', '2566632626', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 95, 'ECONOMY', 'FEMALE', 4322934),
       (25, 'Tabby', 'Tampion', '6353145179', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 48, 'ECONOMY', 'FEMALE', 4817849),
       (26, 'Der', 'Eric', '0954605268', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 49, 'ECONOMY', 'FEMALE', 2315264),
       (27, 'Palm', 'Skrine', '9622513433', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 84, 'ECONOMY', 'FEMALE', 3770077),
       (28, 'Reed', 'Gabbitis', '6471579241', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 94, 'ECONOMY', 'FEMALE', 4919259),
       (29, 'Isidor', 'Chatterton', '2873329599', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 42, 'ECONOMY', 'FEMALE', 3267940),
       (30, 'Ferdinand', 'Verillo', '2630080161', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 96, 'ECONOMY', 'FEMALE', 3552565),
       (31, 'Christen', 'Gemson', '4109509963', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 79, 'ECONOMY', 'FEMALE', 3130029),
       (32, 'Theodore', 'McAvinchey', '7890611676', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 13, 'ECONOMY', 'FEMALE', 4530705),
       (33, 'Farlie', 'Cardoso', '0100414907', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 53, 'ECONOMY', 'FEMALE', 3260322),
       (34, 'Winny', 'Lidstone', '5500001590', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 72, 'ECONOMY', 'FEMALE', 3909425),
       (35, 'Ermina', 'Shelford', '3223261575', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 51, 'ECONOMY', 'FEMALE', 1483684),
       (36, 'Fernande', 'Elgood', '4758367620', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 81, 'ECONOMY', 'FEMALE', 4161817),
       (37, 'Hurlee', 'Flipsen', '9628658123', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 10, 'ECONOMY', 'FEMALE', 4043820),
       (38, 'Aldo', 'Merrifield', '8271305832', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 67, 'ECONOMY', 'FEMALE', 2923504),
       (39, 'Karisa', 'Powlett', '7260642661', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 9, 'ECONOMY', 'FEMALE', 3814757),
       (40, 'Lizzy', 'Corben', '8261463206', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 39, 'ECONOMY', 'FEMALE', 1956143),
       (41, 'Granthem', 'Croall', '7965392585', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 92, 'ECONOMY', 'FEMALE', 2824259),
       (42, 'Sheena', 'Berzin', '0476919266', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 71, 'ECONOMY', 'FEMALE', 3769776),
       (43, 'Dianemarie', 'Walak', '4480653821', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 66, 'ECONOMY', 'FEMALE', 4683740),
       (44, 'Temp', 'Iacovuzzi', '9898499052', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 18, 'ECONOMY', 'FEMALE', 3426810),
       (45, 'Selig', 'Perillio', '9325028379', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 42, 'ECONOMY', 'FEMALE', 3335206),
       (46, 'Bethanne', 'Grammer', '8983283092', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 18, 'ECONOMY', 'FEMALE', 1367071),
       (47, 'Nil', 'Necolds', '7326004013', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 66, 'ECONOMY', 'FEMALE', 1278839),
       (48, 'Laryssa', 'Mayes', '8989953634', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 39, 'ECONOMY', 'FEMALE', 3707276),
       (49, 'Trueman', 'Enoch', '3273343591', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 14, 'ECONOMY', 'FEMALE', 4464633),
       (50, 'Mab', 'Hablet', '2886515558', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 55, 'ECONOMY', 'FEMALE', 4522686),
       (51, 'Sandie', 'Jollands', '0755182898', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 19, 'BUSINESS', 'FEMALE', 4089986),
       (52, 'Janel', 'Boatswain', '0203640810', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 22, 'BUSINESS', 'FEMALE', 1499069),
       (53, 'Tymothy', 'Jimmes', '4473803481', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 98, 'BUSINESS', 'FEMALE', 3491645),
       (54, 'Justen', 'Giacomini', '8686940625', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 35, 'BUSINESS', 'FEMALE', 3966712),
       (55, 'Burl', 'Greveson', '3653305667', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 59, 'BUSINESS', 'FEMALE', 3480950),
       (56, 'Pierre', 'Hembling', '9796777231', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 18, 'BUSINESS', 'FEMALE', 1802003),
       (57, 'Delphine', 'Sonley', '8447409910', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 41, 'BUSINESS', 'FEMALE', 3296108),
       (58, 'Junette', 'Borthe', '8013423905', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 71, 'BUSINESS', 'FEMALE', 1121670),
       (59, 'Kevina', 'Lawford', '1919608052', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 76, 'BUSINESS', 'FEMALE', 1159700),
       (60, 'Shirley', 'Rickets', '9998565677', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 44, 'BUSINESS', 'FEMALE', 4843879),
       (61, 'Dasi', 'Utley', '7382288714', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 30, 'BUSINESS', 'FEMALE', 3570295),
       (62, 'Danny', 'McGeachie', '1690022779', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 77, 'BUSINESS', 'FEMALE', 1248149),
       (63, 'Liesa', 'Heather', '9867958179', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 20, 'BUSINESS', 'FEMALE', 2363989),
       (64, 'Ferdinand', 'Jursch', '5404024259', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 36, 'BUSINESS', 'FEMALE', 4083649),
       (65, 'Desdemona', 'Waliszek', '3552444300', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 38, 'BUSINESS', 'FEMALE', 1336999),
       (66, 'Frankie', 'Ransom', '0645029157', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 17, 'BUSINESS', 'FEMALE', 4271732),
       (67, 'Loleta', 'Trappe', '7390473622', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 32, 'BUSINESS', 'FEMALE', 4873876),
       (68, 'Alli', 'Ranyard', '9360460249', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 13, 'BUSINESS', 'FEMALE', 3068123),
       (69, 'Brennen', 'Hurling', '5204603948', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 23, 'BUSINESS', 'FEMALE', 4587829),
       (70, 'Dora', 'Koschke', '3889496784', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 90, 'BUSINESS', 'FEMALE', 1716066),
       (71, 'Dot', 'Grunwall', '7419429995', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 28, 'BUSINESS', 'FEMALE', 3556506),
       (72, 'Zorah', 'Brockett', '0124746063', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 56, 'BUSINESS', 'FEMALE', 2173617),
       (73, 'Traci', 'Yoodall', '9761113310', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 27, 'BUSINESS', 'FEMALE', 2802118),
       (74, 'Langsdon', 'Wressell', '1250698863', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 36, 'BUSINESS', 'FEMALE', 2096489),
       (75, 'Lucien', 'Gatley', '9878639665', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 66, 'BUSINESS', 'FEMALE', 2167873),
       (76, 'Earlie', 'Sisley', '3806122865', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 3, 'BUSINESS', 'FEMALE', 3094275),
       (77, 'Marven', 'Deely', '9618959929', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 32, 'BUSINESS', 'FEMALE', 2103116),
       (78, 'Yard', 'Shields', '5419033267', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 24, 'BUSINESS', 'FEMALE', 2256368),
       (79, 'Bowie', 'Gazzard', '0982644574', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 40, 'BUSINESS', 'FEMALE', 3850919),
       (80, 'Kate', 'Pacitti', '8626192436', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 44, 'BUSINESS', 'FEMALE', 2382053),
       (81, 'Melba', 'Harold', '9673710643', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 63, 'BUSINESS', 'FEMALE', 1489907),
       (82, 'Elva', 'Durban', '4344941632', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 82, 'BUSINESS', 'FEMALE', 3186930),
       (83, 'Quinton', 'Melody', '2624913386', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 26, 'BUSINESS', 'FEMALE', 1028899),
       (84, 'Skipton', 'Volker', '2324067331', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 50, 'BUSINESS', 'FEMALE', 1213785),
       (85, 'Dennison', 'Hargreave', '2174964104', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 56, 'BUSINESS', 'FEMALE', 3891085),
       (86, 'Aksel', 'Halleghane', '5083854694', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 70, 'BUSINESS', 'FEMALE', 3686914),
       (87, 'Jacinthe', 'Jore', '4766719867', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 41, 'BUSINESS', 'FEMALE', 4644770),
       (88, 'Sheryl', 'Gylle', '8831553399', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 52, 'BUSINESS', 'FEMALE', 1363131),
       (89, 'Monti', 'Challes', '7530440594', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 58, 'BUSINESS', 'FEMALE', 1610838),
       (90, 'Darcey', 'Gleave', '1346986509', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 19, 'BUSINESS', 'FEMALE', 2170534),
       (91, 'Farlay', 'Fanthom', '5591419364', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 94, 'BUSINESS', 'FEMALE', 4796698),
       (92, 'Ofelia', 'Margiotta', '4257018844', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 98, 'BUSINESS', 'FEMALE', 3803498),
       (93, 'Barnebas', 'Rapport', '8056619992', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 47, 'BUSINESS', 'FEMALE', 3574304),
       (94, 'Willi', 'Zottoli', '4089507596', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 98, 'BUSINESS', 'FEMALE', 2323417),
       (95, 'Jaimie', 'Seedhouse', '0437322149', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 77, 'BUSINESS', 'FEMALE', 1661863),
       (96, 'Leah', 'Irnis', '4224724456', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 18, 'BUSINESS', 'FEMALE', 4298560),
       (97, 'Eliot', 'Evanson', '7630522533', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 80, 'BUSINESS', 'FEMALE', 4716343),
       (98, 'Vonnie', 'Sphinxe', '7693638814', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 44, 'BUSINESS', 'FEMALE', 4104521),
       (99, 'Lauren', 'Garvie', '3716149365', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 68, 'BUSINESS', 'FEMALE', 2302686),
       (100, 'Ruth', 'Lehon', '1015479200', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 77, 'BUSINESS', 'FEMALE', 3107337),
       (101, 'Ransom', 'Bessett', '5716556981', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 15, 'BUSINESS', 'MALE', 4404064),
       (102, 'Roxana', 'Matchett', '5055542780', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 5, 'BUSINESS', 'MALE', 2157135),
       (103, 'Dionne', 'Wathell', '7503144351', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 84, 'BUSINESS', 'MALE', 4205750),
       (104, 'Eddie', 'Croster', '6124360136', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 99, 'BUSINESS', 'MALE', 1589106),
       (105, 'Sandy', 'Morewood', '1694961443', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 3, 'BUSINESS', 'MALE', 2272608),
       (106, 'Mauricio', 'Richarson', '2162949547', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 85, 'BUSINESS', 'MALE', 3701914),
       (107, 'Gregoire', 'Siggery', '9669523354', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 41, 'BUSINESS', 'MALE', 2182149),
       (108, 'Meta', 'Ohanessian', '7740713562', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 89, 'BUSINESS', 'MALE', 3131139),
       (109, 'Simonette', 'Kersley', '9885828036', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 15, 'BUSINESS', 'MALE', 1840509),
       (110, 'Brigida', 'Douberday', '3735223605', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 39, 'BUSINESS', 'MALE', 4763938),
       (111, 'Lynnet', 'Iwanowski', '1955468508', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 51, 'BUSINESS', 'MALE', 1173105),
       (112, 'Evaleen', 'Deabill', '2018050230', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 20, 'BUSINESS', 'MALE', 2852160),
       (113, 'Kari', 'Eeles', '8093644822', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 21, 'BUSINESS', 'MALE', 3312175),
       (114, 'Haleigh', 'Menlove', '4178171941', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 23, 'BUSINESS', 'MALE', 1137800),
       (115, 'Sergio', 'Matteau', '1155066898', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 18, 'BUSINESS', 'MALE', 2313677),
       (116, 'Riordan', 'Esterbrook', '0830242554', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 56, 'BUSINESS', 'MALE', 4825993),
       (117, 'Stearn', 'Proven', '1142551849', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 73, 'BUSINESS', 'MALE', 3299826),
       (118, 'Sebastian', 'Hagwood', '1576924831', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 16, 'BUSINESS', 'MALE', 3966769),
       (119, 'Layla', 'Duddan', '9490896349', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 58, 'BUSINESS', 'MALE', 1268896),
       (120, 'Myer', 'Cossum', '2092342983', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 42, 'BUSINESS', 'MALE', 4500682),
       (121, 'Decca', 'Maharg', '3523997003', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 37, 'BUSINESS', 'MALE', 3348904),
       (122, 'Em', 'Armiger', '2998559050', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 19, 'BUSINESS', 'MALE', 1716764),
       (123, 'Ricky', 'Uff', '6168736255', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 68, 'BUSINESS', 'MALE', 1627155),
       (124, 'Krispin', 'Harvatt', '7161506298', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 100, 'BUSINESS', 'MALE', 2413665),
       (125, 'Arluene', 'Ellett', '3764941863', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 49, 'BUSINESS', 'MALE', 1371592),
       (126, 'Burnard', 'Muriel', '7945240534', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 46, 'BUSINESS', 'MALE', 3790636),
       (127, 'Sherilyn', 'Hagley', '6234329780', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 35, 'BUSINESS', 'MALE', 4200145),
       (128, 'Thomasina', 'Candelin', '1182307434', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 96, 'BUSINESS', 'MALE', 2276833),
       (129, 'Xavier', 'Quantick', '9465992607', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 59, 'BUSINESS', 'MALE', 4371289),
       (130, 'Deborah', 'Harborow', '3564221638', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 73, 'BUSINESS', 'MALE', 3294135),
       (131, 'Adlai', 'Howorth', '5752308569', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 15, 'BUSINESS', 'MALE', 4167232),
       (132, 'Milicent', 'Crossman', '8957795170', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 39, 'BUSINESS', 'MALE', 3235203),
       (133, 'Kermy', 'Del Dello', '3892558116', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 21, 'BUSINESS', 'MALE', 3608400),
       (134, 'Benedikt', 'Sharvill', '5496102197', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 47, 'BUSINESS', 'MALE', 2754623),
       (135, 'Romain', 'Saunder', '1124938516', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 40, 'BUSINESS', 'MALE', 1512200),
       (136, 'Martin', 'Salerg', '7365547847', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 13, 'BUSINESS', 'MALE', 2624790),
       (137, 'Orelia', 'Kondratenko', '9857721907', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 86, 'BUSINESS', 'MALE', 1908183),
       (138, 'Katie', 'Clashe', '5009667762', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 6, 'BUSINESS', 'MALE', 1458937),
       (139, 'Cathyleen', 'Brooking', '4703572915', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 16, 'BUSINESS', 'MALE', 4913261),
       (140, 'Khalil', 'Cadell', '4960252588', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 29, 'BUSINESS', 'MALE', 1780628),
       (141, 'Odelinda', 'Yglesias', '8297309428', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 83, 'BUSINESS', 'MALE', 2281974),
       (142, 'Lindsey', 'Hoyes', '5557963103', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 5, 'BUSINESS', 'MALE', 1439740),
       (143, 'Petra', 'Siemon', '2178959350', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 6, 'BUSINESS', 'MALE', 4395063),
       (144, 'Hayes', 'Fitzroy', '0995033145', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 67, 'BUSINESS', 'MALE', 4781577),
       (145, 'Rosetta', 'Hillborne', '4880182621', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 8, 'BUSINESS', 'MALE', 4277049),
       (146, 'Marice', 'Neave', '2274534403', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 46, 'BUSINESS', 'MALE', 3412064),
       (147, 'Dael', 'Beining', '7223350881', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 61, 'BUSINESS', 'MALE', 2746324),
       (148, 'Michale', 'Rodell', '3451813750', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 4, 'BUSINESS', 'MALE', 3405894),
       (149, 'Jenica', 'Mitchard', '5681947777', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 7, 'BUSINESS', 'MALE', 2319486),
       (150, 'Norry', 'Comins', '0777934256', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 68, 'BUSINESS', 'MALE', 4533539),
       (151, 'Tymon', 'Domney', '5159220631', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 5, 'ECONOMY', 'MALE', 3518709),
       (152, 'Tammie', 'Templeton', '3636437100', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 71, 'ECONOMY', 'MALE', 2372396),
       (153, 'Lek', 'Clarkson', '1462343686', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 93, 'ECONOMY', 'MALE', 3758483),
       (154, 'Flossie', 'Kear', '8531205581', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 47, 'ECONOMY', 'MALE', 2359876),
       (155, 'Elinor', 'Bysh', '6921735443', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 53, 'ECONOMY', 'MALE', 3389576),
       (156, 'Klara', 'Allchorne', '6285543771', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 13, 'ECONOMY', 'MALE', 4786698),
       (157, 'Marney', 'Van Walt', '6513357209', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 85, 'ECONOMY', 'MALE', 1340552),
       (158, 'Nichols', 'Peagram', '6931779966', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 87, 'ECONOMY', 'MALE', 2379285),
       (159, 'Hillier', 'Cassidy', '8377585642', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 5, 'ECONOMY', 'MALE', 3064023),
       (160, 'Doralynne', 'Comer', '0711171173', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 30, 'ECONOMY', 'MALE', 2827879),
       (161, 'Gertruda', 'Gullis', '1776000811', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 70, 'ECONOMY', 'MALE', 2929160),
       (162, 'Ritchie', 'Zuker', '2355235392', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 52, 'ECONOMY', 'MALE', 3034843),
       (163, 'Janine', 'Barnby', '5778364547', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 27, 'ECONOMY', 'MALE', 2129724),
       (164, 'Fayina', 'McCloch', '2974232248', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 74, 'ECONOMY', 'MALE', 3757825),
       (165, 'Jere', 'Leidl', '1287282857', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 71, 'ECONOMY', 'MALE', 2206370),
       (166, 'Burtie', 'Clist', '2001311206', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 86, 'ECONOMY', 'MALE', 4316338),
       (167, 'Garrik', 'Rawkesby', '8115649260', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 2, 'ECONOMY', 'MALE', 2665816),
       (168, 'Mahmoud', 'Hassey', '2666815757', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 8, 'ECONOMY', 'MALE', 2134302),
       (169, 'Kiley', 'Castiello', '0231289057', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 5, 'ECONOMY', 'MALE', 2720795),
       (170, 'Ferdinand', 'Wrathmell', '7170468484', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 50, 'ECONOMY', 'MALE', 1374489),
       (171, 'Hendrik', 'Matzeitis', '3681477302', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 34, 'ECONOMY', 'MALE', 4734095),
       (172, 'Malanie', 'Sleford', '1153536234', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 100, 'ECONOMY', 'MALE', 3432530),
       (173, 'Tybalt', 'McCowen', '1398182915', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 21, 'ECONOMY', 'MALE', 2098614),
       (174, 'Leigh', 'Drowsfield', '8672710266', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 97, 'ECONOMY', 'MALE', 2993895),
       (175, 'Guido', 'Brockton', '1011690225', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 91, 'ECONOMY', 'MALE', 3740863),
       (176, 'Hermina', 'Rossin', '3624012509', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 28, 'ECONOMY', 'MALE', 4812698),
       (177, 'Niven', 'Jobb', '0180416707', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 6, 'ECONOMY', 'MALE', 3161760),
       (178, 'Mattie', 'Gaines', '6833105669', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 5, 'ECONOMY', 'MALE', 2423126),
       (179, 'Natal', 'Hanbury-Brown', '3891584911', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 69, 'ECONOMY', 'MALE', 1755542),
       (180, 'Enriqueta', 'Marriot', '0873210972', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 50, 'ECONOMY', 'MALE', 4860422),
       (181, 'Alfonso', 'Eldered', '9301310139', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 20, 'ECONOMY', 'MALE', 3008878),
       (182, 'Illa', 'Machel', '2009239555', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 13, 'ECONOMY', 'MALE', 1998687),
       (183, 'Burgess', 'Parrin', '4532693675', 2, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 37, 'ECONOMY', 'MALE', 1446031),
       (184, 'Consuela', 'Ondrus', '0116878851', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 36, 'ECONOMY', 'MALE', 1516646),
       (185, 'Patricia', 'Powling', '5898599908', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 40, 'ECONOMY', 'MALE', 4656475),
       (186, 'Alvinia', 'Halfhead', '7147637747', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 53, 'ECONOMY', 'MALE', 3963437),
       (187, 'Gaylor', 'Drews', '5992839658', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 23, 'ECONOMY', 'MALE', 4140914),
       (188, 'Estrellita', 'McGilroy', '2641090139', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 57, 'ECONOMY', 'MALE', 3118758),
       (189, 'Holmes', 'Leander', '4680611901', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 80, 'ECONOMY', 'MALE', 1373654),
       (190, 'Charmane', 'Gramer', '1461318807', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 54, 'ECONOMY', 'MALE', 4204528),
       (191, 'Benyamin', 'Beardsdale', '9635100272', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 19, 'ECONOMY', 'MALE', 1171769),
       (192, 'Elisha', 'Palumbo', '8002541588', 6, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 14, 'ECONOMY', 'MALE', 3968264),
       (193, 'Colin', 'Arnold', '1589545478', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 31, 'ECONOMY', 'MALE', 4375388),
       (194, 'Caresse', 'Link', '2345135220', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 78, 'ECONOMY', 'MALE', 1842698),
       (195, 'Norine', 'Cock', '3346894762', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 46, 'ECONOMY', 'MALE', 2078387),
       (196, 'Raf', 'Rickersey', '8587572997', 3, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 78, 'ECONOMY', 'MALE', 3478899),
       (197, 'Chelsey', 'Jarmyn', '7445614427', 4, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 47, 'ECONOMY', 'MALE', 3007835),
       (198, 'Barby', 'Heffernan', '4564666797', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 24, 'ECONOMY', 'MALE', 1576489),
       (199, 'Blythe', 'Ibbison', '5571655445', 1, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 93, 'ECONOMY', 'MALE', 3074876),
       (200, 'Alika', 'Tregenna', '2611381283', 5, to_timestamp('21 Nov 2022', 'DD Mon YYYY'), 79, 'ECONOMY', 'MALE', 4996890);

INSERT INTO complete (ticket_number, survey_id, "time")
VALUES (1, 1, now()),
       (2, 1, now()),
       (3, 1, to_timestamp('10 Dec 2022', 'DD Mon YYYY')),
       (4, 1, now()),
    --    (4, 1, now()),
    --    (5, 2, now()),
    --    (6, 2, now()),
       (1, 3, now()),
       (2, 3, now()),
       (4, 3, now());

INSERT INTO question (id, survey_id, text, class, is_mandatory, type)
VALUES (1, 1, 'Please describe your experience with us.', 'ECONOMY', true, 'DESCRIPTIVE'),
       (2, 1, 'Which food would you like on your flight?', 'BUSINESS', true, 'DESCRIPTIVE'),
       (3, 1, 'Rate your experience.', 'ECONOMY', true, 'MULTIPLE_CHOICE'),
       (4, 1, 'Will you be flying with us again?', 'BUSINESS', true, 'MULTIPLE_CHOICE'),
       (5, 4, 'Please describe your experience with us.', 'ECONOMY', true, 'DESCRIPTIVE'),
       (6, 4, 'Which food would you like on your flight?', 'BUSINESS', true, 'DESCRIPTIVE'),
       (7, 4, 'Rate your experience.', 'ECONOMY', true, 'MULTIPLE_CHOICE'),
       (8, 4, 'Will you be flying with us again?', 'BUSINESS', true, 'MULTIPLE_CHOICE'),
       (9, 3, 'Rate the food', 'BUSINESS', true, 'MULTIPLE_CHOICE');

INSERT INTO answers (question_id, ticket_number, "value")
VALUES (1, 1, 'Excellent'),
       (1, 2, 'Excellent'),
       (2, 1, 'Pizza'),
       (2, 2, 'Pizza'),
       (3, 2, '10'),
       (3, 1, '10'),
       (3, 4, '9'),
    --    (9, 3, 'BAD'),
       (9, 1, 'BAD'),
       (9, 2, 'GOOD'),
       (9, 4, 'BAD');

INSERT INTO choice (question_id, text)
VALUES (3, '0'),
       (3, '1'),
       (3, '3'),
       (3, '4'),
       (3, '5'),
       (3, '6'),
       (3, '7'),
       (3, '8'),
       (3, '9'),
       (3, '10'),
       (4, 'YES'),
       (4, 'NO'),
       (7, '0'),
       (7, '1'),
       (7, '3'),
       (7, '4'),
       (7, '5'),
       (7, '6'),
       (7, '7'),
       (7, '8'),
       (7, '9'),
       (7, '10'),
       (8, 'YES'),
       (8, 'NO'),
       (9, 'BAD'),
       (9, 'MEDIUM'),
       (9, 'GOOD');

INSERT INTO validates (question_id, supervisor_username)
VALUES (1, 'supervisor-1'),
       (2, 'supervisor-1'),
       (3, 'supervisor-2'),
       (9, 'supervisor-2');
