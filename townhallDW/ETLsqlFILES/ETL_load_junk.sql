-- Reset identity
DBCC CHECKIDENT ('Junk', RESEED, 0);

-- Merge all possible combinations into Junk table
MERGE INTO Junk AS target
USING (
    SELECT 
        sm.submission_method_name,
        dn.document_name,
        st.status_name
    FROM 
        (VALUES ('Online'), ('In person')) AS sm(submission_method_name)
    CROSS JOIN 
        (VALUES 
            ('ID card'), 
            ('Passport'), 
            ('Birth certificate'), 
            ('Marriage Certificate'), 
            ('Driving license')
        ) AS dn(document_name)
    CROSS JOIN 
        (VALUES ('Pending'), ('Completed'), ('Rejected')) AS st(status_name)
) AS source
ON 
    target.submission_method_name = source.submission_method_name
    AND target.document_name = source.document_name
    AND target.status_name = source.status_name
WHEN NOT MATCHED BY TARGET THEN
    INSERT (submission_method_name, document_name, status_name)
    VALUES (source.submission_method_name, source.document_name, source.status_name);
