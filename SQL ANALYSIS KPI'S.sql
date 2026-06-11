--KPI'S
--1: Total Flights
SELECT COUNT(*) AS total_flights
FROM flights;

--2: Completed Flights
SELECT COUNT(*) AS completed_flights
FROM flights
WHERE cancelled = 0;

--Cancelled Flights %
SELECT 
    (SUM(cancelled) * 100.0 / COUNT(*)) AS cancellation_rate
FROM flights;

--4: On-Time Performance %
SELECT 
    (COUNT(*) FILTER (WHERE arrival_delay <= 0) * 100.0) 
    / COUNT(*) AS on_time_percentage
FROM flights
WHERE cancelled = 0;

--5: Average Arrival Delay
SELECT AVG(arrival_delay) AS avg_arrival_delay
FROM flights
WHERE cancelled = 0;

--6: Average Departure Delay
SELECT AVG(departure_delay) AS avg_departure_delay
FROM flights
WHERE cancelled = 0;

--7: Total Delay Minutes
SELECT SUM(arrival_delay) AS total_delay_minutes
FROM flights
WHERE cancelled = 0;

--8: Delay Percentage (>15 min)
SELECT 
    (COUNT(*) FILTER (WHERE arrival_delay > 15) * 100.0) 
    / COUNT(*) AS delay_percentage
FROM flights
WHERE cancelled = 0;