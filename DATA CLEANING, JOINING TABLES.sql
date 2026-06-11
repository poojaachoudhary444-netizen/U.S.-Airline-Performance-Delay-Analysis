CREATE TABLE flights (
    year INT,
    month INT,
    day INT,
    day_of_week INT,
    airline VARCHAR(10),
    flight_number INT,
    tail_number VARCHAR(10),
    origin_airport VARCHAR(10),
    destination_airport VARCHAR(10),
    scheduled_departure INT,
    departure_time INT,
    departure_delay INT,
    taxi_out INT,
    wheels_off INT,
    scheduled_time INT,
    elapsed_time INT,
    air_time INT,
    distance INT,
    wheels_on INT,
    taxi_in INT,
    scheduled_arrival INT,
    arrival_time INT,
    arrival_delay INT,
    diverted INT,
    cancelled INT,
    cancellation_reason VARCHAR(5),
    air_system_delay INT,
    security_delay INT,
    airline_delay INT,
    late_aircraft_delay INT,
    weather_delay INT
);

CREATE TABLE airlines (
    iata_code VARCHAR(5),
    airline VARCHAR(100)
);

CREATE TABLE airports (
    iata_code VARCHAR(10),
    airport VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    latitude FLOAT,
    longitude FLOAT
);

-- =========================
-- STEP 1: DATA CHECK
-- =========================
SELECT COUNT(*) FROM flights;
SELECT COUNT(*) FROM airlines;
SELECT COUNT(*) FROM airports;
SELECT * FROM flights;
SELECT * FROM airlines;
SELECT * FROM airports;

-- =========================
-- STEP 2: DATA CLEANING
-- =========================
-- Create Date Column
ALTER TABLE flights ADD COLUMN flight_date DATE;

UPDATE flights
SET flight_date = TO_DATE(
    CONCAT(year, '-', month, '-', day),
    'YYYY-MM-DD'
);
SELECT * FROM flights;
--Check Null Values
SELECT COUNT(*) 
FROM flights
WHERE arrival_delay IS NULL;

UPDATE flights
SET arrival_delay = 0
WHERE arrival_delay IS NULL;

UPDATE flights
SET departure_delay = 0
WHERE departure_delay IS NULL;
--Remove Duplicate Records
SELECT year, month, day, airline, flight_number,
       COUNT(*) AS duplicate_count
FROM flights
GROUP BY year, month, day, airline, flight_number
HAVING COUNT(*) > 1;

--Standardize Time Format
ALTER TABLE flights 
ADD COLUMN dep_time_formatted TIME;

UPDATE flights
SET dep_time_formatted = 
    TO_TIMESTAMP(
        LPAD(
            CASE 
                WHEN departure_time = 2400 THEN 0
                ELSE departure_time
            END::text, 
        4, '0'), 
    'HH24MI')::TIME;

--adding column Delay Category
ALTER TABLE flights ADD COLUMN delay_status VARCHAR(20);

UPDATE flights
SET delay_status = 
CASE 
    WHEN arrival_delay <= 0 THEN 'On Time'
    WHEN arrival_delay <= 15 THEN 'Minor Delay'
    ELSE 'Major Delay'
END;
SELECT * FROM flights;
--Flight Time Bucket (Morning/Evening)
ALTER TABLE flights ADD COLUMN time_of_day VARCHAR(20);

UPDATE flights
SET time_of_day =
CASE 
    WHEN departure_time BETWEEN 500 AND 1200 THEN 'Morning'
    WHEN departure_time BETWEEN 1201 AND 1700 THEN 'Afternoon'
    ELSE 'Evening/Night'
END;

--Clean Cancellation Reasons
ALTER TABLE flights ADD COLUMN cancel_reason_desc TEXT;

UPDATE flights
SET cancel_reason_desc =
CASE cancellation_reason
    WHEN 'A' THEN 'Airline Issue'
    WHEN 'B' THEN 'Weather'
    WHEN 'C' THEN 'Air System'
    WHEN 'D' THEN 'Security'
END;

--Check Outliers in Distance
SELECT *
FROM flights
WHERE distance = 0 OR distance > 10000;

CREATE TABLE flights_clean AS
SELECT *
FROM flights
WHERE cancelled = 0
AND arrival_delay IS NOT NULL;

UPDATE flights
SET
    departure_delay     = COALESCE(departure_delay, 0),
    arrival_delay       = COALESCE(arrival_delay, 0),
    airline_delay       = COALESCE(airline_delay, 0),
    weather_delay       = COALESCE(weather_delay, 0),
    late_aircraft_delay = COALESCE(late_aircraft_delay, 0),
    air_system_delay    = COALESCE(air_system_delay, 0),
    security_delay      = COALESCE(security_delay, 0)
WHERE cancelled = 0;
SELECT *
FROM flights
WHERE cancelled = 0;

--Join Tables---
SELECT f.*, a.airline
FROM flights f
JOIN airlines a
ON f.airline = a.iata_code;

SELECT f.*, ap.city, ap.state
FROM flights f
JOIN airports ap
ON f.origin_airport = ap.iata_code;
SELECT * FROM flights_clean
SELECT * FROM flights
SELECT COUNT(*) AS total_rows
FROM flights;