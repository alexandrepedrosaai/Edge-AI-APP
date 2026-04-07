-- Stored procedure: calculate average sensor value
CREATE OR REPLACE PROCEDURE calc_avg_readings IS
    avg_val NUMBER;
BEGIN
    SELECT AVG(value) INTO avg_val FROM sensor_readings;
    INSERT INTO inferences (input_value, result)
    VALUES (avg_val, CASE WHEN avg_val > 0.5 THEN 'active' ELSE 'inactive' END);
END;
/

-- Trigger: auto-log pipeline test after insert
CREATE OR REPLACE TRIGGER log_pipeline_test
AFTER INSERT ON sensor_readings
FOR EACH ROW
BEGIN
    INSERT INTO pipeline_tests (test_name, status)
    VALUES ('Auto Trigger', 'executed');
END;
/
