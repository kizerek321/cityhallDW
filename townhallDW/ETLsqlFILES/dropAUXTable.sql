IF OBJECT_ID('AuxDelayReason', 'U') IS NOT NULL
BEGIN
    DROP TABLE AuxDelayReason;
END

IF OBJECT_ID('AuxRequestReason', 'U') IS NOT NULL
BEGIN
    DROP TABLE AuxRequestReason;
END