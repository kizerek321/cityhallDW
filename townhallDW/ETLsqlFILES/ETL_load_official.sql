-- No DELETE or RESEED to preserve historical data

MERGE INTO DimOfficial AS target
USING (
    SELECT 
        CAST(official_ID AS INT) AS official_key,
        CONCAT(name1, ' ', IIF(name2 = '', '', CONCAT(name2, ' ')), surname) AS full_name,
        email,
        CASE 
            WHEN department LIKE '%Legal%' THEN 'Legal Affairs'
            ELSE 'Citizen Services'
        END AS department
	FROM TOWNHALL.dbo.OFFICIAL
) AS source
ON target.official_key = source.official_key AND target.is_working = 1

WHEN MATCHED AND (
    target.full_name <> source.full_name OR
    target.email <> source.email OR
    target.department <> source.department
) THEN
    -- 1. Expire the old record
    UPDATE SET target.is_working = 0

WHEN NOT MATCHED BY TARGET THEN
    -- 2. Insert the new current record
    INSERT (official_key, full_name, email, department, is_working)
    VALUES (source.official_key, source.full_name, source.email, source.department, 1);
