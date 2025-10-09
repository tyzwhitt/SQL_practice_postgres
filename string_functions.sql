--sting functions ; lets clean up some data
-- trim leading and trailing spaces from a string
--CONCATENATE two or more strings

SELECT city ||'------'|| address AS full_address
    FROM customer;

SELECT concat(city, address)
    FROM customer;

SELECT concat_ws(' - ', city, address)
    FROM customer;

SELECT trim(both ' ' from city) AS trimmed_city
    FROM customer;

SELECT trim( ' Hello      ');

SELECT trim( 'x' from 'xxxxxhelloxxxxx');


SELECT upper(customer_name) from customer;

SELECT lower(customer_name) from customer;

SELECT initcap(customer_name) from customer; -- capitalize first letter of each word

SELECT substring(customer_name from 1 for 2) from customer; -- first 2 characters

Select left(customer_name, 2) from customer; -- first 2 characters

Select right(customer_name, 2) from customer; -- last 2 characters

SELECT position('Bob' in customer_name) from customer; -- position of first space