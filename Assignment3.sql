/*
 * Assignment number 3
 * Demo: https://dbfiddle.uk/?rdbms=mysql_8.0&fiddle=9e63b4e1012589290ced948bea2ef101
 * /

/*
 * Create 'people' table
 * */
DROP TABLE IF EXISTS people;
CREATE TABLE people(
    id INT(11) NOT NULL AUTO_INCREMENT,
    NAME VARCHAR(255),
    PRIMARY KEY(id)
);

/* 
 * Populate 'people' table with data
 * */
INSERT INTO people(NAME) VALUES("john");
INSERT INTO people(NAME) VALUES("mary");
INSERT INTO people(NAME) VALUES("chen");

/*
 * Create Pet table
 * */
DROP TABLE IF EXISTS pet;
CREATE TABLE pet(
    id INT(11) NOT NULL AUTO_INCREMENT,
    NAME VARCHAR(255),
    PRIMARY KEY(id)
);

/* 
 * Populate 'pet' table with data
 * */
INSERT INTO pet(NAME) VALUES("dog");
INSERT INTO pet(NAME) VALUES("parrot");
INSERT INTO pet(NAME) VALUES("cat");

/*
 * Create Vehicle table
 * */
DROP TABLE IF EXISTS vehicle;
CREATE TABLE vehicle(
    id INT(11) NOT NULL AUTO_INCREMENT,
    NAME VARCHAR(255),
    PRIMARY KEY(id)
);

/* 
 * Populate 'vehicle' table with data
 * */
INSERT INTO vehicle(NAME) VALUES("truck");
INSERT INTO vehicle(NAME) VALUES("car");
INSERT INTO vehicle(NAME) VALUES("bike");

/*
 * Create Linking table for pets to people
 * */
DROP TABLE IF EXISTS pet__people;
CREATE TABLE pet__people(
	id INT(11) NOT NULL AUTO_INCREMENT,
    pet_id INT(11) NOT NULL,
    people_id INT(11) NOT NULL,
    PRIMARY KEY(id)
);

/*
 * Create Linking table for vehicles to people
 * */
DROP TABLE IF EXISTS vehicle__people;
CREATE TABLE vehicle__people(
	id INT(11) NOT NULL AUTO_INCREMENT,
    vehicle_id INT(11) NOT NULL,
    people_id INT(11) NOT NULL,
    PRIMARY KEY(id)
);


/* 
 * Populate 'pet__people' table with data
 * give john a doggo
 * */
INSERT INTO pet__people(pet_id, people_id)
VALUES(
	(SELECT id FROM pet WHERE name = 'dog'),
	(SELECT id FROM people WHERE name = 'john')
);

/* 
 * Populate 'pet__people' table with data
 * give chen a parrot
 * */
INSERT INTO pet__people(pet_id, people_id)
VALUES(
    (SELECT id FROM pet WHERE name = 'parrot'),
	(SELECT id FROM people WHERE name = 'chen')
);

/* 
 * Populate 'pet__people' table with data
 * give chen a cat
 * */
INSERT INTO pet__people(pet_id, people_id)
VALUES(
    (SELECT id FROM pet WHERE name = 'cat'),
	(SELECT id FROM people WHERE name = 'chen')
);

/* 
 * Populate 'vehicle__people' table with data
 * give mary a truck
 * */
INSERT INTO vehicle__people(vehicle_id, people_id)
VALUES(
    (SELECT id FROM vehicle WHERE name = 'truck'),
	(SELECT id FROM people WHERE name = 'mary')
);

/* 
 * Populate 'vehicle__people' table with data
 * give john 2 trucks & 2 cars
 * */
INSERT INTO vehicle__people(vehicle_id, people_id)
VALUES(
    (SELECT id FROM vehicle WHERE NAME = 'truck'),
	(SELECT id FROM people WHERE NAME = 'john')
);
INSERT INTO vehicle__people(vehicle_id, people_id)
VALUES(
    (SELECT id FROM vehicle WHERE NAME = 'truck'),
	(SELECT id FROM people WHERE NAME = 'john')
);
INSERT INTO vehicle__people(vehicle_id, people_id)
VALUES(
    (SELECT id FROM vehicle WHERE NAME = 'car'),
	(SELECT id FROM people WHERE NAME = 'john')
);
INSERT INTO vehicle__people(vehicle_id, people_id)
VALUES(
    (SELECT id FROM vehicle WHERE NAME = 'car'),
	(SELECT id FROM people WHERE NAME = 'john')
);


/*
 * Return a list of people with their vehicles, count of vehicles
*/
SELECT
    pe.name as name,
    vj.vehiclename as vehicles,
    vj.vehiclecount
FROM
    people pe
LEFT JOIN(
    SELECT vp.people_id people_id,
        GROUP_CONCAT(v.name) vehiclename,
        COUNT(vp.people_id) vehiclecount
    FROM
        vehicle v
    JOIN vehicle__people vp ON
        v.id = vp.vehicle_id
    GROUP BY
        people_id
) vj
ON
    pe.id = vj.people_id


/*
 * Return a list of people with their pets and count of pets
*/
SELECT
    pe.name as name,
    pj.petname as pets,
    pj.petcount
FROM
    people pe
LEFT JOIN(
    SELECT pp.people_id people_id,
        GROUP_CONCAT(p.name) petname,
        COUNT(pp.people_id) petcount
    FROM
        pet p
    JOIN pet__people pp ON
        p.id = pp.pet_id
    GROUP BY
        people_id
) pj
ON
    pe.id = pj.people_id;
	
/*
 * Return people that have atleast 2 pets
 */
SELECT
    peeps.people_id as PersonID,
    GROUP_CONCAT(p.name) as Pets,
    COUNT(peeps.people_id) as Pet_Count
FROM
    pet p
    	JOIN pet__people peeps
     	ON p.id = peeps.pet_id
GROUP BY PersonID
HAVING
	COUNT(*) >= 2
	
/*
 * Return people that have atleast 2 vehicles
 */
SELECT
    peeps.people_id as PersonID,
    GROUP_CONCAT(v.name) as Vehicles,
    COUNT(peeps.people_id) as Vehicle_Count
FROM
    vehicle v
    	JOIN vehicle__people peeps
     	ON v.id = peeps.vehicle_id
GROUP BY PersonID
HAVING
	COUNT(*) >= 2
	
/*
 * Return a list of people with their pets and count of pets
 * Return a list of people with their vehicles, count of vehicles
*/
SELECT
    pe.name as name,
    vj.vehiclename as vehicles,
    vj.vehiclecount,
    pj.petname as pets,
    pj.petcount
FROM
    people pe
LEFT JOIN(
    SELECT vp.people_id people_id,
        GROUP_CONCAT(v.name) vehiclename,
        COUNT(vp.people_id) vehiclecount
    FROM
        vehicle v
    JOIN vehicle__people vp ON
        v.id = vp.vehicle_id
    GROUP BY
        people_id
) vj
ON
    pe.id = vj.people_id
LEFT JOIN(
    SELECT pp.people_id people_id,
        GROUP_CONCAT(p.name) petname,
        COUNT(pp.people_id) petcount
    FROM
        pet p
    JOIN pet__people pp ON
        p.id = pp.pet_id
    GROUP BY
        people_id
) pj
ON
    pe.id = pj.people_id;