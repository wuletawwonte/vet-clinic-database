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

-- QUERIES FOR QUESTIONS 

-- Who was the last animal seen by William Tatcher?
SELECT WT.Vet_name, WT.date_of_visit, WT.animal FROM 
(SELECT Vt.name AS Vet_name, Vs.date_of_visit, A.name AS animal FROM vets Vt
JOIN visits Vs ON Vt.id = Vs.vet_id
JOIN animals A ON Vs.animal_id = A.id
WHERE Vt.name = 'William Tatcher') AS WT
WHERE date_of_visit = (SELECT MAX(WT.date_of_visit) FROM (SELECT Vt.name AS Vet_name, Vs.date_of_visit, A.name AS animal FROM vets Vt
JOIN visits Vs ON Vt.id = Vs.vet_id
JOIN animals A ON Vs.animal_id = A.id
WHERE Vt.name = 'William Tatcher') AS WT);

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(SM.animal) FROM (SELECT Count(Vt.name) AS No_of_Vet_name, A.name AS animal FROM vets Vt
JOIN visits Vs ON Vt.id = Vs.vet_id JOIN animals A ON Vs.animal_id = A.id
WHERE Vt.name = 'Stephanie Mendez'
GROUP BY A.name) AS SM;

-- List all vets and their specialties, including vets with no specialties.
SELECT Vt.id, Vt.name AS Vet_name, Sp.name AS specialty FROM vets Vt
LEFT JOIN specializations Sn ON Vt.id = Sn.vet_id
LEFT JOIN species Sp ON Sn.species_id = Sp.id; 

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT Vt.name AS Vet_name, A.name AS animal, Vs.date_of_visit FROM vets Vt
JOIN visits Vs ON Vt.id = Vs.vet_id
JOIN animals A ON Vs.animal_id = A.id
WHERE Vt.name = 'Stephanie Mendez' 
AND (Vs.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30');

-- What animal has the most visits to vets?
SELECT AL.animal, AL.Vet_visits FROM
(SELECT A.name AS animal, COUNT(Vt.name) AS Vet_visits FROM vets Vt
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
  GROUP BY A.name
) as AL
WHERE AL.Vet_visits = (SELECT MAX(AL.Vet_visits) FROM (SELECT A.name AS animal, COUNT(Vt.name) AS Vet_visits FROM vets Vt
JOIN visits Vs ON Vt.id = Vs.vet_id
JOIN animals A ON Vs.animal_id = A.id
GROUP BY A.name) as AL);

-- Who was Maisy Smith's first visit?
SELECT MS.Vet_name, MS.animal, MS.date_of_visit FROM
(SELECT Vt.name AS Vet_name, A.name AS animal, Vs.date_of_visit FROM vets Vt
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
  WHERE Vt.name = 'Maisy Smith'
) AS MS
WHERE MS.date_of_visit = (SELECT MIN(MS.date_of_visit) FROM 
(SELECT Vt.name AS Vet_name, A.name AS animal, Vs.date_of_visit FROM vets Vt
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
  WHERE Vt.name = 'Maisy Smith'
) AS MS);

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT A.*, Vt.*, Vs.date_of_visit FROM vets Vt
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
WHERE date_of_visit = (SELECT MAX(MD.date_of_visit) FROM (SELECT Vt.*, A.*, Vs.date_of_visit FROM vets Vt
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id) As MD);

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(MS.Vet_name) AS visits FROM 
(SELECT  Vt.name AS Vet_name, A.name AS animal, Vs.date_of_visit, Sp.name as specialty FROM vets Vt
  LEFT JOIN specializations Sz ON Vt.id = Sz.vet_id
  LEFT JOIN species Sp ON Sz.species_id = Sp.id
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
  WHERE Sp.name IS NULL) as MS;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT S.name AS Species_name, MS2.species_id, MS2.Total_number AS Total_number_of_species FROM species S
JOIN (SELECT MS.species_id, MS.Total_number FROM 
(SELECT A.species_id, COUNT(A.species_id) AS Total_number FROM vets Vt
  LEFT JOIN specializations Sz ON Vt.id = Sz.vet_id
  LEFT JOIN species Sp ON Sz.species_id = Sp.id
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
  WHERE Vt.name = 'Maisy Smith'
  GROUP BY A.species_id) as MS
WHERE MS.Total_number = (SELECT MAX(MS.Total_number) FROM
(SELECT A.species_id, COUNT(A.species_id) AS Total_number FROM vets Vt
  LEFT JOIN specializations Sz ON Vt.id = Sz.vet_id
  LEFT JOIN species Sp ON Sz.species_id = Sp.id
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
  WHERE Vt.name = 'Maisy Smith'
  GROUP BY A.species_id) as MS)) AS MS2
  ON S.id = MS2.species_id; 