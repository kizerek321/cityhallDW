BULK INSERT REQUEST
FROM 'C:\Users\krzys\PycharmProjects\DW\fake_requests_T1.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,  -- Skip header
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001' -- UTF-8 encoding
);
BULK INSERT CITIZEN
FROM 'C:\Users\krzys\PycharmProjects\DW\fake_citizens.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,  -- Skip header
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001' -- UTF-8 encoding
);
BULK INSERT OFFICIAL
FROM 'C:\Users\krzys\PycharmProjects\DW\fake_cityhall_workers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,  -- Skip header
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001' -- UTF-8 encoding
);
