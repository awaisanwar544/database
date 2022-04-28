/*Queries that provide answer to the questions from all projects.*/

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

SELECT name FROM animals JOIN owners ON owners.id = animals.owner_id WHERE owners.full_name = 'Melody Pond';
SELECT animals.name FROM animals JOIN species ON species.id = animals.species_id WHERE species.name = 'Pokemon';
SELECT animals.name, full_name FROM animals RIGHT JOIN owners on owners.id = animals.owner_id;
SELECT species.name, COUNT(*) FROM animals JOIN species ON species.id = animals.species_id GROUP BY species.name;
SELECT animals.name FROM animals JOIN species ON species.id = animals.species_id JOIN owners ON owners.id = animals.owner_id WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';
SELECT animals.name FROM animals JOIN owners ON owners.id = animals.owner_id WHERE escape_attempts = 0 AND owners.full_name = 'Dean Winchester';
SELECT owners.full_name, COUNT(*) as total FROM animals JOIN owners ON owners.id = animals.owner_id GROUP BY owners.full_name ORDER BY total DESC LIMIT 1;


/* Who was the last animal seen by William Tatcher? */
SELECT animals.name, vets.name, visits.visit_date FROM animals JOIN visits ON visits.animal_id = animals.id JOIN vets ON visits.vets_id = vets.id WHERE vets.name = 'William Tatcher' ORDER BY visits.visit_date DESC LIMIT 1;
/* How many different animals did Stephanie Mendez see? */
SELECT ROW_NUMBER() OVER (ORDER BY animals.name) FROM animals JOIN visits ON visits.animal_id = animals.id JOIN vets ON visits.vets_id = vets.id WHERE vets.name = 'Stephanie Mendez' GROUP BY animals.name, vets.name ORDER BY ROW_NUMBER() OVER (ORDER BY animals.name) DESC LIMIT 1;
/* List all vets and their specialties, including vets with no specialties. */
SELECT vets.name, species.name FROM vets LEFT JOIN specializations ON vets_id = vets.id LEFT JOIN species ON species_id = species.id;
/* List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. */
SELECT animals.name FROM animals JOIN visits ON visits.animal_id = animals.id JOIN vets ON visits.vets_id = vets.id WHERE vets.name = 'Stephanie Mendez' AND visits.visit_date BETWEEN '2020-04-01' AND '2020-08-30';
/* What animal has the most visits to vets? */
SELECT animals.name, COUNT(*) FROM animals JOIN visits ON visits.animal_id = animals.id GROUP BY animals.name ORDER BY COUNT(*) DESC LIMIT 1;
/* Who was Maisy Smith's first visit? */
SELECT animals.name, vets.name, visits.visit_date FROM animals JOIN visits ON visits.animal_id = animals.id JOIN vets ON visits.vets_id = vets.id WHERE vets.name = 'Maisy Smith' ORDER BY visits.visit_date ASC LIMIT 1;
/* Details for most recent visit: animal information, vet information, and date of visit. */
SELECT animals.name, vets.name, visits.visit_date FROM animals JOIN visits ON visits.animal_id = animals.id JOIN vets ON visits.vets_id = vets.id ORDER BY visits.visit_date DESC LIMIT 1;
/* How many visits were with a vet that did not specialize in that animal's species? */
SELECT COUNT(animals.name) FROM visits INNER JOIN animals ON animal_id= animals.id INNER JOIN vets ON vets_id=vets.id WHERE animals.species_id NOT IN((SELECT species_id FROM specializations WHERE vets_id=visits.vets_id));
/* What specialty should Maisy Smith consider getting? Look for the species she gets the most. */
SELECT species.name FROM animals INNER JOIN visits ON animals.id=animal_id INNER JOIN vets ON vets_id=vets.id INNER JOIN species ON animals.species_id=species.id WHERE vets.name='Maisy Smith' GROUP BY species.name ORDER BY  COUNT(species.name) DESC LIMIT 1;
