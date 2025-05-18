IF EXISTS (SELECT 1 FROM DimTime)
    DELETE FROM DimTime;
DBCC CHECKIDENT ('DimTime', RESEED, 0);
DECLARE @Hour INT = 0;

WHILE @Hour <= 23
BEGIN
    INSERT INTO DimTime (hour, time_of_day)
    VALUES (
        @Hour,
        CASE 
            WHEN @Hour BETWEEN 0 AND 5 THEN 'Night'
            WHEN @Hour BETWEEN 6 AND 11 THEN 'Morning'
            WHEN @Hour BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END
    );
    
    SET @Hour = @Hour + 1;
END;
