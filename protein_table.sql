use sars_cov_2;

DROP TABLE IF EXISTS protein_kod_sekv;
DROP TABLE IF EXISTS granice_proteini;

CREATE TABLE granice_proteini(
	accession_prot VARCHAR(255) NOT NULL,
	protein VARCHAR(255),
	leva_granica int NOT NULL,
	desna_granica int NOT NULL,
	PRIMARY KEY (accession_prot)
);

CREATE TABLE protein_kod_sekv(
	id VARCHAR(255) NOT NULL,
	accession_prot VARCHAR(255) NOT NULL,
	protein VARCHAR(255) NOT NULL,
	leva_granica int NOT NULL,
	desna_granica int NOT NULL,
	duzina_nuc int not null,
	kod_nuc TEXT NOT NULL,
	PRIMARY KEY (id,accession_prot)
);
