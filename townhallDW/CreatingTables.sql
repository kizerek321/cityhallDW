USE TOWNHALL;
CREATE TABLE OFFICIAL (
    official_ID VARCHAR(8) PRIMARY KEY,
    department VARCHAR(50),
    name1 VARCHAR(30),
    name2 VARCHAR(30) DEFAULT '',
    surname VARCHAR(30),
    email VARCHAR(50)
);

CREATE TABLE CITIZEN (
    PESEL VARCHAR(11) PRIMARY KEY,
    name1 VARCHAR(30),
    name2 VARCHAR(30) DEFAULT '',
    surname VARCHAR(30),
    birth_date DATE
);

CREATE TABLE REQUEST (
    request_ID VARCHAR(10) PRIMARY KEY,
    official_ID VARCHAR(8),
    PESEL VARCHAR(11),
    document_ID VARCHAR(10),
    document_name VARCHAR(30),
    submission_date DATE,
    processing_start_date DATE,
    estimated_completion_date DATE,
    completion_date DATE NULL,
    status VARCHAR(10),
    submission_method VARCHAR(10),
    FOREIGN KEY (official_ID) REFERENCES OFFICIAL(official_ID),
    FOREIGN KEY (PESEL) REFERENCES CITIZEN(PESEL)
);