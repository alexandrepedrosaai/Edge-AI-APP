-- Initial data
INSERT INTO sensors (name, type) VALUES
('Temperature Sensor', 'analog'),
('Motion Sensor', 'digital'),
('Light Sensor', 'analog');

INSERT INTO sensor_readings (sensor_id, value) VALUES
(1, 0.65),
(2, 1.00),
(3, 0.25);

INSERT INTO inferences (input_value, result) VALUES
(0.9, 'active'),
(0.1, 'inactive');

INSERT INTO pipeline_tests (test_name, status) VALUES
('Threshold Test', 'passed'),
('Inference Logic', 'passed');
