IF (object_id('DW.dbo.AuxRequestReason') is not null) DELETE FROM AuxRequestReason;

DBCC CHECKIDENT ('DimRequestReason', RESEED, 0);

BULK INSERT AuxRequestReason
FROM 'C:\temp\request_reasons_T1.csv'
WITH (
	FORMAT = 'CSV',
    FIRSTROW = 2, -- if your CSV has headers
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',
    TABLOCK,
	CODEPAGE = '65001'
);
-- Merge data into the dimension table using ReasonID
MERGE INTO DimRequestReason AS target
USING (
    SELECT 
        ReasonID,
        if_first_request,
        is_expired,
        is_data_update,
        other_reason
    FROM AuxRequestReason
) AS source
ON target.request_reason_key = source.ReasonID

WHEN MATCHED THEN
    UPDATE SET
        if_first_request = source.if_first_request,
        is_expired = source.is_expired,
        is_data_update = source.is_data_update

WHEN NOT MATCHED BY TARGET THEN
    INSERT (request_reason_key, if_first_request, is_expired, is_data_update)
    VALUES (source.ReasonID, source.if_first_request, source.is_expired, source.is_data_update);