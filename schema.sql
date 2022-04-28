/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT,
    neutered BOOLEAN NOT NULL,
    weight_kg NUMERIC
);

ALTER TABLE animals ADD COLUMN species VARCHAR(250);

CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(250) NOT NULL,
    age INT
);

CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250) NOT NULL
);

ALTER TABLE animals ADD CONSTRAINT animals_pkey PRIMARY KEY (id);

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INT;
ALTER TABLE species ADD CONSTRAINT species_pkey PRIMARY KEY (id);
ALTER TABLE animals ADD CONSTRAINT species_id_fkey FOREIGN KEY (species_id) REFERENCES species(id);

ALTER TABLE animals ADD COLUMN owner_id INT;
ALTER TABLE owners ADD CONSTRAINT owners_pkey PRIMARY KEY (id);
ALTER TABLE animals ADD CONSTRAINT owner_id_fkey FOREIGN KEY (owner_id) REFERENCES owners(id);

/* create vets table */

CREATE TABLE vets (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(250) NOT NULL,
    age INT,
    date_of_graduation DATE,
    PRIMARY KEY (id)
);

/* create specializations table */

CREATE TABLE specializations (
    vets_id INT REFERENCES vets(id) ON DELETE CASCADE ON UPDATE CASCADE,
    species_id INT REFERENCES species(id) ON DELETE CASCADE ON UPDATE CASCADE
);

/* create visits table */

CREATE TABLE visits (
    vets_id INT REFERENCES vets(id) ON DELETE CASCADE ON UPDATE CASCADE,
    animal_id INT REFERENCES animals(id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE visits ADD COLUMN visit_date DATE;