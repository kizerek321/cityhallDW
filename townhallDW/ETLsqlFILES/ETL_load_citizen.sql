-- Declare a variable for the fixed date
--DECLARE @reference_date DATE = '2026-05-10';

-- Do not delete data to preserve history
-- No DBCC CHECKIDENT since we are not reseeding or resetting

MERGE INTO DimCitizen AS target
USING (
    SELECT 
        PESEL,
        CONCAT(name1, ' ', IIF(name2 = '', '', CONCAT(name2, ' ')), surname) AS full_name,
        birth_date,
        DATEDIFF(YEAR, birth_date, '2026-05-10') AS age,
        CASE 
            WHEN DATEDIFF(YEAR, birth_date, '2026-05-10') BETWEEN 0 AND 17 THEN '0-17'
            WHEN DATEDIFF(YEAR, birth_date, '2026-05-10') BETWEEN 18 AND 23 THEN '18-23'
            WHEN DATEDIFF(YEAR, birth_date, '2026-05-10') BETWEEN 24 AND 30 THEN '24-30'
            WHEN DATEDIFF(YEAR, birth_date, '2026-05-10') BETWEEN 31 AND 63 THEN '31-63'
            ELSE '64+'
        END AS age_group
    FROM TOWNHALL.dbo.CITIZEN
) AS source
ON target.pesel = source.PESEL AND target.is_current = 1

-- 1. If data has changed, expire the old record
WHEN MATCHED AND (
	target.pesel <> source.PESEL OR
    target.full_name <> source.full_name OR
    target.birth_date <> source.birth_date OR
    target.age <> DATEDIFF(YEAR, source.birth_date, '2026-05-10') OR
    target.age_group <> 
        CASE 
            WHEN DATEDIFF(YEAR, source.birth_date, '2026-05-10') BETWEEN 0 AND 17 THEN '0-17'
            WHEN DATEDIFF(YEAR, source.birth_date, '2026-05-10') BETWEEN 18 AND 23 THEN '18-23'
            WHEN DATEDIFF(YEAR, source.birth_date, '2026-05-10') BETWEEN 24 AND 30 THEN '24-30'
            WHEN DATEDIFF(YEAR, source.birth_date, '2026-05-10') BETWEEN 31 AND 63 THEN '31-63'
            ELSE '64+'
        END
) THEN
    -- Expire the old record if it matches but is different
    UPDATE SET target.is_current = 0

-- 2. Insert new record when data has changed or is entirely new
WHEN NOT MATCHED BY TARGET THEN
    -- Insert new record only if no current record exists with the same PESEL
    INSERT (pesel, full_name, birth_date, age, age_group, is_current)
    VALUES (
        source.PESEL,
        source.full_name,
        source.birth_date,
        DATEDIFF(YEAR, source.birth_date, '2026-05-10'),
        source.age_group,
        1
    );

-- Optional: Handle the case where a citizen already exists with is_current = 1 by marking the current one as expired.
-- This may be necessary if duplicates are occurring due to pre-existing data.
