-- 1. Prepare dimension lookups using CTEs
WITH CitizenLookup AS (
    SELECT pesel, citizen_id
    FROM DimCitizen
	WHERE is_current = 1
),
OfficialLookup AS (
    SELECT official_key, official_id
    FROM DimOfficial
),
SubmissionDateLookup AS (
    SELECT date, date_id
    FROM DimDate
),
ProcessingStartDateLookup AS (
    SELECT date, date_id
    FROM DimDate
),
EstimatedCompletionDateLookup AS (
    SELECT date, date_id
    FROM DimDate
),
CompletionDateLookup AS (
    SELECT date, date_id
    FROM DimDate
),
JunkLookup AS (
    SELECT 
        submission_method_name, 
        document_name, 
        status_name, 
        junk_id
    FROM Junk
),
RequestReasonLookup AS (
    SELECT
        request_reason_key,
        request_reason_id
    FROM DimRequestReason
),
DelayReasonLookup AS (
    SELECT
        delay_reason_key,
        delay_reason_id
    FROM DimDelayReason
)

-- 2. Final Insert into FactDocumentRequest
INSERT INTO FactDocumentRequest (
    request_no,
    submission_date_id,
    processing_start_date_id,
    estimated_completion_date_id,
    completion_date_id,
    citizen_id,
    official_id,
    request_reason_id,
    delay_reason_id,
    junk_id,
    waiting_time,
    processing_time,
    total_time,
    is_delayed,
    delay_duration,
    standard_processing_time,
    processing_efficiency
)
SELECT
    R.request_id as request_no,
    SubDate.date_id AS submission_date_id,
    ProcStartDate.date_id AS processing_start_date_id,
    EstComplDate.date_id AS estimated_completion_date_id,
    ComplDate.date_id AS completion_date_id,
    C.citizen_id,
    O.official_id,
    RR.request_reason_id,
    DR.delay_reason_id,
    J.junk_id,

    DATEDIFF(DAY, R.submission_date, R.processing_start_date) AS waiting_time,
    DATEDIFF(DAY, R.processing_start_date, ISNULL(R.completion_date, '2030-01-01')) AS processing_time,
    DATEDIFF(DAY, R.submission_date, ISNULL(R.completion_date, '2030-01-01')) AS total_time,

    CASE 
        WHEN ISNULL(R.completion_date, '2030-01-01') > R.estimated_completion_date THEN 1
        ELSE 0
    END AS is_delayed,

    CASE 
        WHEN ISNULL(R.completion_date, '2030-01-01') > R.estimated_completion_date 
        THEN DATEDIFF(DAY, R.estimated_completion_date, ISNULL(R.completion_date, '2030-01-01'))
        ELSE 0
    END AS delay_duration,

    DATEDIFF(DAY, R.processing_start_date, R.estimated_completion_date) AS standard_processing_time,

    CAST(DATEDIFF(DAY, R.processing_start_date, ISNULL(R.completion_date, '2030-01-01')) AS FLOAT) /
    NULLIF(DATEDIFF(DAY, R.processing_start_date, R.estimated_completion_date), 0) AS processing_efficiency

FROM TOWNHALL.dbo.REQUEST R

-- Dimension joins
INNER JOIN CitizenLookup C ON R.PESEL = C.pesel
INNER JOIN OfficialLookup O ON CAST(R.official_ID AS INT) = O.official_key
INNER JOIN SubmissionDateLookup SubDate ON R.submission_date = SubDate.date
INNER JOIN ProcessingStartDateLookup ProcStartDate ON R.processing_start_date = ProcStartDate.date
INNER JOIN EstimatedCompletionDateLookup EstComplDate ON R.estimated_completion_date = EstComplDate.date
INNER JOIN CompletionDateLookup ComplDate ON ISNULL(R.completion_date, '2030-01-01') = ComplDate.date
INNER JOIN JunkLookup J 
    ON R.submission_method = J.submission_method_name
    AND R.document_name = J.document_name
    AND R.status = J.status_name

-- Fact joins via business key = ReasonID (mapped from request_id earlier)
INNER JOIN RequestReasonLookup RR ON R.request_ID = RR.request_reason_key
INNER JOIN DelayReasonLookup DR ON R.request_ID = DR.delay_reason_key;
