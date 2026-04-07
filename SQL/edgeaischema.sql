-- Create database
CREATE DATABASE edge_ai_app;
USE edge_ai_app;

-- Sensors table
CREATE TABLE sensors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sensor readings table
CREATE TABLE sensor_readings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    value FLOAT NOT NULL,
    reading_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sensor_id) REFERENCES sensors(id)
);

-- Inferences table
CREATE TABLE inferences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    input_value FLOAT NOT NULL,
    result VARCHAR(50) NOT NULL,
    inference_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Pipeline tests table
CREATE TABLE pipeline_tests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(100),
    status VARCHAR(20),
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
