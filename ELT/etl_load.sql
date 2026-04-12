-- Inserir leituras de sensores
INSERT INTO sensor_readings (sensor_id, value, reading_time)
VALUES (:sensor_id, :value, :reading_time);

-- Registrar log de carga
INSERT INTO etl_logs (source, status, load_time)
VALUES (:source, 'completed', CURRENT_TIMESTAMP);
