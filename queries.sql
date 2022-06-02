/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';

SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT * FROM animals WHERE neutered = true AND escape_attempts < 3;

SELECT name, date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered = true;

SELECT * FROM animals WHERE name != 'Gabumon';

SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

BEGIN TRANSACTION;

UPDATE animals SET species = 'unspecified';

SELECT * FROM animals;

ROLLBACK;

BEGIN TRANSACTION;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

COMMIT TRANSACTION;

SELECT * FROM animals;

BEGIN TRANSACTION;

DELETE FROM animals;

ROLLBACK;

-- BEGIN TRANSACTION 

BEGIN TRANSACTION;

DELETE FROM animals WHERE date_of_birth > '2022-01-01';

SAVEPOINT save_point;

UPDATE animals SET weight_kg = weight_kg * -1;

SELECT * FROM animals;

ROLLBACK TO save_point;

UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

SELECT * FROM animals;

COMMIT TRANSACTION;

-- END TRANSACTION

-- QUERIES FOR QUESTIONS 

-- How many animals are there?
SELECT COUNT(*) FROM animals;
-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;
-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;
-- What is the minimum and maximum weight of each type of animal?
SELECT neutered, MAX(weight_kg) as Max_weight, MIN(weight_kg) as Max_weight  FROM animals GROUP BY neutered;
-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT neutered, AVG(escape_attempts) as Average_escape_attempts FROM animals WHERE date_of_birth <= '2000-12-31' AND date_of_birth >= '1990-01-01' GROUP BY neutered;