CREATE OR REPLACE FUNCTION random_text()
    RETURNS TEXT
    LANGUAGE PLPGSQL
    AS $$
    DECLARE
        possible_chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        output TEXT := '';
        i INT4;
        pos INT4;
    BEGIN

        FOR i IN 1..random() * 15 LOOP
            pos := FLOOR( (length(possible_chars) + 1) * random());
            output := output || substr(possible_chars, pos, 1);
        END LOOP;

        RETURN output;
    END;
    $$;

CREATE OR REPLACE FUNCTION random_country()
    RETURNS TEXT
    LANGUAGE PLPGSQL
    AS $$
    DECLARE
	possible_countries TEXT ARRAY  DEFAULT  ARRAY['FRANCE', 'GERMANY', 'AUSTRIA', 'ROMANIA', 'HUNGARY', 'SPAIN', 'PORTUGAL', 'ITALY'];
    BEGIN

        RETURN possible_countries[FLOOR(random() * array_length(possible_countries, 1)) + 1];
    END;
    $$;

CREATE TABLE addresses (
	id INTEGER NOT NULL,
	city VARCHAR(40) NOT NULL,
	country VARCHAR(40) NOT NULL,
	street VARCHAR(40) NOT NULL
);

CREATE TABLE employees (
	id INTEGER NOT NULL,
	company_id INTEGER NOT NULL,
	dep INTEGER NOT NULL,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	salary INTEGER,
	address_id INTEGER
);

INSERT INTO addresses 
SELECT id, random_text() as city, random_country() as country, random_text() as street from (select generate_series(1, 100000) as id) as id;

INSERT INTO employees
SELECT id, FLOOR(random() * 100 + 1) as company, FLOOR(random() * 20 + 1) as dep, random_text() as last_name, random_text() as first_name, FLOOR(random() * 2000) as salary, FLOOR(random() * 100000) + 1 as address_id FROM (select generate_series(1, 100000) as id) as id;
