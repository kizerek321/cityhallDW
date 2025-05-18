IF EXISTS (SELECT 1 FROM DimDate)
    DELETE FROM DimDate;
DBCC CHECKIDENT ('DimDate', RESEED, 0);

DECLARE @CurrentDate DATE = '2020-01-01';

WHILE @CurrentDate <= '2030-12-31'
BEGIN
    INSERT INTO DimDate (date, day_of_week, day_of_week_num, month_num, month_name, year)
    VALUES (
        @CurrentDate,
        DATENAME(WEEKDAY, @CurrentDate),
        DATEPART(WEEKDAY, @CurrentDate),
        MONTH(@CurrentDate),
        DATENAME(MONTH, @CurrentDate),
        YEAR(@CurrentDate)
    );
    
    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END;