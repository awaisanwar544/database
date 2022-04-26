/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name LIKE '%mon';
SELECT name from animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name from animals WHERE neutered AND escape_attempts < 3;
SELECT date_of_birth from animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts from animals WHERE weight_kg > 10.5;
SELECT * from animals WHERE neutered;
SELECT * from animals WHERE name != 'Gabumon';
SELECT * from animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/* Transactions */
UPDATE animals SET species = 'unspecified' RETURNING *;
ROLLBACK;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon' RETURNING *;
UPDATE animals SET species = 'pokemon' WHERE species IS NULL RETURNING *;
COMMIT;
SELECT * FROM animals;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT del_first;
UPDATE animals SET weight_kg = weight_kg * -1 RETURNING *;
ROLLBACK TO del_first;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0 RETURNING *;
COMMIT;

/* Queries */
SELECT count(*) FROM animals;
SELECT count(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, SUM(escape_attempts) as total FROM animals GROUP BY neutered;
SELECT species, MAX(weight_kg), MIN(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;
