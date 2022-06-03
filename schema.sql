/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic;

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL,
    PRIMARY KEY (id)
);

ALTER TABLE animals ADD species VARCHAR(100);

CREATE TABLE owners(id INT GENERATED ALWAYS AS IDENTITY, full_name VARCHAR(100), age INT, PRIMARY KEY (id));

CREATE TABLE species(id INT GENERATED ALWAYS AS IDENTITY, name VARCHAR(100), PRIMARY KEY(id));

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE ANIMALS ADD species_id INT;

ALTER TABLE animals ADD CONSTRAINT animal_species FOREIGN KEY (species_id) REFERENCES species (id);

ALTER TABLE animals ADD owner_id INT;

ALTER TABLE animals ADD CONSTRAINT animal_owner FOREIGN KEY (owner_id) REFERENCES owners (id);

CREATE TABLE vets (id INT GENERATED ALWAYS AS IDENTITY, name VARCHAR(100), age INT, date_of_graduation DATE, PRIMARY KEY(id));

CREATE TABLE specializations (id INT GENERATED ALWAYS AS IDENTITY, species_id INT, vet_id INT, FOREIGN KEY (species_id) REFERENCES species (id), FOREIGN KEY (vet_id) REFERENCES vets (id));