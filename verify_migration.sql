SET HEADING ON
SET FEEDBACK ON

PROMPT === Verifying Tables ===
SELECT table_name FROM user_tables ORDER BY table_name;

PROMPT === Verifying Triggers ===
SELECT trigger_name FROM user_triggers ORDER BY trigger_name;

PROMPT === Verifying Row Counts ===
SELECT 'Users' AS table_name, COUNT(*) AS row_count FROM Users
UNION ALL
SELECT 'Courses', COUNT(*) FROM Courses
UNION ALL
SELECT 'Enrollments', COUNT(*) FROM Enrollments;

EXIT;