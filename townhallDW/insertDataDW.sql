-- DimDate Table
INSERT INTO DimDate (date, day_of_week, day_of_week_num, month_num, month_name, year) VALUES
('2025-04-15', 'Tuesday', 2, 4, 'April', 2025),
('2025-04-16', 'Wednesday', 3, 4, 'April', 2025),
('2025-04-17', 'Thursday', 4, 4, 'April', 2025);

-- DimTime Table
INSERT INTO DimTime (hour, time_of_day) VALUES
(9, '0-8'),
(14, '9-12'),
(20, '12-15');

-- DimCitizen Table
INSERT INTO DimCitizen (pesel, full_name, birth_date, age, age_group, is_current) VALUES
('90010112345', 'Anna Kowalska', '1990-01-01', 35, '24-30', 1),
('05052067890', 'Piotr Nowak', '2005-05-20', 19, '18-23', 1),
('55121054321', 'Maria Wiœniewska', '1955-12-10', 69, '64+', 1);

-- DimOfficial Table
INSERT INTO DimOfficial (official_key, full_name, email, department, is_working) VALUES
(101, 'Janusz Lewandowski', 'janusz.lewandowski@gov.pl', 'Citizen Services', 1),
(102, 'Katarzyna Zaj¹c', 'katarzyna.zajac@gov.pl', 'Legal Affairs', 1),
(103, 'Marek D¹browski', 'marek.dabrowski@gov.pl', 'Citizen Services', 0);

-- DimRequestReason Table
INSERT INTO DimRequestReason (if_first_request, is_expired, is_data_update) VALUES
(1, 0, 0),
(0, 1, 0),
(0, 0, 1);

-- DimDelayReason Table
INSERT INTO DimDelayReason (has_all_data, missing_data, is_queue_significant, other_reason) VALUES
(1, 'None', 0, 'None'),
(0, 'Address proof', 0, 'None'),
(0, 'None', 1, 'System overload');

-- Junk Table
INSERT INTO Junk (submission_method_name, document_name, status_name) VALUES
('Online', 'ID card', 'Pending'),
('In person', 'Passport', 'Completed'),
('Online', 'Birth certificate', 'Rejected');

-- FactDocumentRequest Table
INSERT INTO FactDocumentRequest (request_no, submission_date_id, processing_start_date_id, estimated_completion_date_id, completion_date_id, time_id, citizen_id, official_id, request_reason_id, delay_reason_id, junk_id, waiting_time, processing_time, total_time, is_delayed, delay_duration, standard_processing_time, processing_efficiency) VALUES
(1, 1, 1, 2, 2,1, 1, 1, 1, 1, 1, 5, 10, 15, 0, 0, 10, 1.00),
(2, 1, 2, 3, 3, 2, 2, 2, 2, 2, 2, 2, 15, 17, 1, 3, 12, 0.80),
(3, 2, 3, 1, 1, 3, 3, 1, 3, 3, 3, 8, 7, 15, 0, 0, 8, 0.88);