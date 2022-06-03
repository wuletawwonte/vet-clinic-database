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

SELECT full_name AS owner, name AS animal FROM owners JOIN animals ON owners.id = animals.owner_id WHERE owners.full_name = 'Melody Pond';

SELECT animals.name as animal, species.name as species FROM species S JOIN animals A ON S.id = A.species_id WHERE S.name = 'Pokemon';

SELECT A.name as animal, S.name as species FROM species S JOIN animals A ON S.id = A.species_id WHERE S.name = 'Pokemon';

SELECT O.full_name as Owner, A.name as Animals FROM owners O LEFT JOIN animals A ON O.id = A.owner_id;

SELECT S.name as Species, COUNT(A.name) as Total_number FROM species S JOIN animals A ON S.id = A.species_id
GROUP BY S.name;

SELECT O.full_name as owner, A.name as animal, S.name as type 
FROM owners O JOIN animals A ON O.id = A.owner_id
JOIN species S ON S.id = A.species_id
WHERE O.full_name = 'Jennifer Orwell' AND S.name = 'Digimon';

SELECT O.full_name as owner, A.name as animal 
FROM owners O JOIN animals A ON O.id = A.owner_id
WHERE O.full_name = 'Dean Winchester' AND A.escape_attempts = 0;

SELECT agg.full_name as owner, count as Total_number FROM
(SELECT full_name, count(a.owner_id) FROM owners O
JOIN animals A ON O.id = A.owner_id GROUP BY O.full_name) AS agg 
WHERE count = (SELECT MAX(count) FROM (SELECT full_name, count(a.owner_id) FROM owners O
JOIN animals A ON O.id = A.owner_id GROUP BY O.full_name) AS agg); 