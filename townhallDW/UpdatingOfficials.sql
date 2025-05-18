
CREATE TABLE temp_officials (
    official_id VARCHAR(8) PRIMARY KEY,
    department VARCHAR(50),
    name1 VARCHAR(30),
    name2 VARCHAR(30) DEFAULT '',
    surname VARCHAR(30),
    email VARCHAR(50)
);
BULK INSERT temp_officials
FROM 'C:\Users\krzys\PycharmProjects\DW\fake_cityhall_workers_T3.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001' -- Optional: UTF-8
);

MERGE OFFICIAL AS target
USING temp_officials AS source
ON target.official_ID = source.official_id
WHEN MATCHED THEN
    UPDATE SET target.department = source.department
WHEN NOT MATCHED THEN
    INSERT (official_ID, department, name1, name2, surname, email)
	VALUES (source.official_id, source.department, source.name1, source.name2, source.surname, source.email);
DROP TABLE temp_officials;
