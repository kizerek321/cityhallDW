CREATE TABLE DimDate (
    date_id INT PRIMARY KEY IDENTITY(1,1),
    date DATE NOT NULL,
    day_of_week VARCHAR(10),
    day_of_week_num INT,
    month_num INT,
    month_name VARCHAR(10),
    year INT
);

CREATE TABLE DimTime (
    time_id INT PRIMARY KEY IDENTITY(1,1),
    hour INT CHECK (hour BETWEEN 0 AND 23),
    time_of_day VARCHAR(15)
);

CREATE TABLE DimCitizen (
    citizen_id INT PRIMARY KEY IDENTITY(1,1),
    pesel VARCHAR(11) UNIQUE,
    full_name VARCHAR(50),
    birth_date DATE,
    age INT,
    age_group VARCHAR(10),
    is_current BIT
);

CREATE TABLE DimOfficial (
    official_id INT PRIMARY KEY IDENTITY(1,1),
    official_key INT,
    full_name VARCHAR(50),
    email VARCHAR(75),
    department VARCHAR(20) CHECK (department IN ('Legal Affairs', 'Citizen Services')),
    is_working BIT
);

CREATE TABLE DimRequestReason (
    request_reason_id INT PRIMARY KEY IDENTITY(1,1),
	request_reason_key INT,
    if_first_request BIT,
    is_expired BIT,
    is_data_update BIT
);

CREATE TABLE DimDelayReason (
    delay_reason_id INT PRIMARY KEY IDENTITY(1,1),
	delay_reason_key INT,
    has_all_data BIT,
    missing_data VARCHAR(25),
    is_queue_significant BIT,
    other_reason VARCHAR(25)
);

CREATE TABLE Junk(
	junk_id INT PRIMARY KEY IDENTITY(1,1),
    submission_method_name VARCHAR(25) CHECK (submission_method_name IN ('In person', 'Online')),
    document_name VARCHAR(25) CHECK (
        document_name IN (
            'ID card',
            'Passport',
            'Birth certificate',
            'Marriage Certificate',
            'Driving license'
        )
    ),
    status_name VARCHAR(25) CHECK (status_name IN ('Pending', 'Completed', 'Rejected'))
);

CREATE TABLE FactDocumentRequest (
	request_no INT,
    submission_date_id INT,
    processing_start_date_id INT,
    estimated_completion_date_id INT,
    completion_date_id INT,
	time_id INT,
    citizen_id INT,
    official_id INT,
    request_reason_id INT,
    delay_reason_id INT,
    junk_id INT,
    
    waiting_time INT,
    processing_time INT,
    total_time INT,
    is_delayed BIT,
    delay_duration INT,
    standard_processing_time INT,
    processing_efficiency FLOAT,

	CONSTRAINT composite_pk PRIMARY KEY (
		request_no,
		submission_date_id,
		processing_start_date_id,
		estimated_completion_date_id,
		completion_date_id,
		time_id,
		citizen_id,
		request_reason_id,
		delay_reason_id,
		junk_id
	),
    FOREIGN KEY (submission_date_id) REFERENCES DimDate(date_id),
    FOREIGN KEY (processing_start_date_id) REFERENCES DimDate(date_id),
    FOREIGN KEY (estimated_completion_date_id) REFERENCES DimDate(date_id),
    FOREIGN KEY (completion_date_id) REFERENCES DimDate(date_id),
	FOREIGN KEY (time_id) REFERENCES DimTime(time_id),
    FOREIGN KEY (citizen_id) REFERENCES DimCitizen(citizen_id),
    FOREIGN KEY (official_id) REFERENCES DimOfficial(official_id),
    FOREIGN KEY (request_reason_id) REFERENCES DimRequestReason(request_reason_id),
    FOREIGN KEY (delay_reason_id) REFERENCES DimDelayReason(delay_reason_id),
    FOREIGN KEY (junk_id) REFERENCES Junk(junk_id)
);
