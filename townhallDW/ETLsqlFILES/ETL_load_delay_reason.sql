IF (object_id('DW.dbo.AuxDelayReason') is not null)
    DELETE FROM AuxDelayReason;
DBCC CHECKIDENT ('DimDelayReason', RESEED, 0);
-- Then MERGE into Dimension
BULK INSERT AuxDelayReason
FROM 'C:\temp\delay_reasons_T1.csv'
WITH (
	FORMAT = 'CSV',
    FIRSTROW = 2, -- if your CSV has headers
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
    TABLOCK,
	CODEPAGE = '65001'
);
MERGE INTO DimDelayReason AS target
USING (
    SELECT 
        ReasonID,
        has_all_data,
        missing_data,
        is_queue_significant,
        other_reason
    FROM DW.dbo.AuxDelayReason
) AS source
ON 
    target.delay_reason_key = source.ReasonID  -- now part of DIM
WHEN MATCHED THEN
    UPDATE SET
        has_all_data = source.has_all_data,
        missing_data = source.missing_data,
        is_queue_significant = source.is_queue_significant,
        other_reason = source.other_reason
WHEN NOT MATCHED BY TARGET THEN
    INSERT (delay_reason_key, has_all_data, missing_data, is_queue_significant, other_reason)
    VALUES (source.ReasonID, source.has_all_data, source.missing_data, source.is_queue_significant, source.other_reason);
