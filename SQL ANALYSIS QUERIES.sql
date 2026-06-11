--QUERIES
-- 1. Average Delay by Airline
SELECT airline,
       AVG(arrival_delay) AS avg_delay
FROM flights
WHERE cancelled = 0
GROUP BY airline
ORDER BY avg_delay DESC;

--2. Top 10 Airlines with Most Delays
SELECT airline,
       COUNT(*) AS delayed_flights
FROM flights
WHERE arrival_delay > 15
AND cancelled = 0
GROUP BY airline
ORDER BY delayed_flights DESC
LIMIT 10;

--3. Cancellation Rate by Airline
SELECT airline,
       (SUM(cancelled) * 100.0 / COUNT(*)) AS cancellation_rate
FROM flights
GROUP BY airline
ORDER BY cancellation_rate DESC;

--Delay by Month
SELECT month,
       AVG(arrival_delay) AS avg_delay
FROM flights
WHERE cancelled = 0
GROUP BY month
ORDER BY month;

--5. Delay by Day of Week
SELECT day_of_week,
       AVG(arrival_delay) AS avg_delay
FROM flights
WHERE cancelled = 0
GROUP BY day_of_week
ORDER BY day_of_week;

--6. Top 10 Most Delayed Airports
SELECT origin_airport,
       AVG(arrival_delay) AS avg_delay
FROM flights
WHERE cancelled = 0
GROUP BY origin_airport
ORDER BY avg_delay DESC
LIMIT 10;

--7. Distance vs Delay Analysis
SELECT 
    CASE 
        WHEN distance < 500 THEN 'Short'
        WHEN distance BETWEEN 500 AND 1500 THEN 'Medium'
        ELSE 'Long'
    END AS distance_category,
    AVG(arrival_delay) AS avg_delay
FROM flights
WHERE cancelled = 0
GROUP BY distance_category;

--8. Delay Reasons Breakdown
SELECT 
    SUM(weather_delay) AS weather_delay,
    SUM(airline_delay) AS airline_delay,
    SUM(air_system_delay) AS air_system_delay,
    SUM(security_delay) AS security_delay,
    SUM(late_aircraft_delay) AS late_aircraft_delay
FROM flights;