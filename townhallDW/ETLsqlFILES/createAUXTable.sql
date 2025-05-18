IF OBJECT_ID('AuxDelayReason', 'U') IS NULL
BEGIN
    CREATE TABLE AuxDelayReason (
		ReasonID INT,
        has_all_data BIT,
        missing_data VARCHAR(100),
        is_queue_significant BIT,
        other_reason VARCHAR(100)
    );
END

IF OBJECT_ID('AuxRequestReason', 'U') IS NULL
BEGIN
    CREATE TABLE AuxRequestReason (
		ReasonID INT,
        if_first_request BIT,
        is_expired BIT,
        is_data_update BIT,
		other_reason VARCHAR(255)
    );
END