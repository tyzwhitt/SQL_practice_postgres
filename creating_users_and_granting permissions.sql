--creating users

SELECT current_user;
--checking current user

CREATE ROLE tyzwh WITH LOGIN PASSWORD '123' SUPERUSER;
--should be able to login with superuser at end
CREATE ROLE tyzwh WITH PASSWORD '123' SUPERUSER;
--should be able to add full access with superuser at end
--granting privileges
GRANT ALL PRIVILEGES ON DATABASE sql_practice_postgres TO tyzwh;

---creating a guest user with limited access
CREATE ROLE guest WITH PASSWORD '435';
GRANT CONNECT ON DATABASE sql_practice_postgres TO guest;
GRANT USAGE ON SCHEMA public TO guest;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO guest;

--creating an admin user with create role ability
CREATE ROLE admin WITH PASSWORD '678'CREATEROLE;

CREATE ROLE guest2 WITH PASSWORD '890' in role guest;
--should be able to create a user with the same privileges as guest aka cloneing user role

CREATE user guest3 WITH PASSWORD '111' in role guest;
--should be able to create a user with the same privileges as guest aka cloneing user role

--granting role to a user
GRANT tyzwh TO guest3 FOR 24 HOURS;
--should be able to give guest3 superuser privileges

GRANT INSERT, UPDATE, DELETE TO adin ON customer;
--should be able to give admin insert, update, delete privileges on customer table

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public guest2;
--should be able to give guest2 all privileges on all tables in public schema