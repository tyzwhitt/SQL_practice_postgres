--Date & Time Functions
SELECT CURRENT_DATE; -- Returns the current date
SELECT CURRENT_TIME; -- Returns the current time


SELECT EXTRACT(YEAR FROM CURRENT_DATE); -- Extracts the year from the current date
SELECT EXTRACT(MONTH FROM CURRENT_DATE); -- Extracts the month from the current date
SELECT EXTRACT(DAY FROM CURRENT_DATE); -- Extracts the day from the current date
SELECT EXTRACT(HOUR FROM CURRENT_TIME); -- Extracts the hour from the current time
SELECT EXTRACT(MINUTE FROM CURRENT_TIME); -- Extracts the minute from the current time
SELECT EXTRACT(SECOND FROM CURRENT_TIME); -- Extracts the second from the current time
SELECT NOW(); -- Returns the current date and time
SELECT AGE(TIMESTAMP '2023-01-01', TIMESTAMP '2000-01-01'); -- Calculates the age between two timestamps


SELECT date_trunc('month', CURRENT_DATE); -- Truncates the current date to the start of the month

SELECT age(timestamp '2024-01-01'); -- Calculates the age from a specific date to the current date

SELECT to_date('01/01/2024', 'DD/MM/YYYY'); -- Converts a string to a date

SELECT to_char(CURRENT_DATE, 'DD-MM-YYYY'); -- Formats the current date as a string

SELECT LOCALTIME; -- Returns the current local time
SELECT LOCALTIMESTAMP; -- Returns the current local 

SELECT extract(hour from order_timestamp) FROM orders; -- Extracts the hour from the order timestamp in the orders tabletimestamp

SELECT date_trunc('day',order_timestamp) FROM orders; -- Trunctates the order timestamp to the start of the day in the orders table

SELECT age(order_timestamp) FROM orders; -- Calculates the age from the order timestamp to the current date in the orders table

SELECT age(delivery_timestamp, order_timestamp) FROM orders; -- Calculates the age between the delivery timestamp and order timestamp in the orders table

SELECT CURRENT_TIMESTAMP at TIME ZONE 'America/New_York'; -- Returns the current timestamp in the specified time zone

