--Stored procedures allow you to encapsulate complex operations in a single call.
--They can accept parameters, perform operations, and return results.
--CREATE PROCEDURE procedure_name (parameters)
--LANGUAGE plpgsql 
--AS $$
--BEGIN
--    -- procedure body
--END;
--$$;
--CALL procedure_name (arguments);
--drop procedure if exists procedure_name (parameters);


CREATE PROCEDURE add_category(cat_id int, cat_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO categories VALUES(cat_id, cat_name);
END;
$$;

CALL add_category(6, 'Fashion');

SELECT * FROM categories;

DROP PROCEDURE if exists add_category;