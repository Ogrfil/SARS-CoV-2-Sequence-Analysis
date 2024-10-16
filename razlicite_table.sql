DROP TABLE IF EXISTS razlike_proteina;

CREATE TABLE razlike_proteina (
    mesec smallint NOT NULL,
    godina smallint NOT NULL,
    id_sekvence1 VARCHAR(255) NOT NULL,
    id_sekvence2 VARCHAR(255) NOT NULL,
    zemlja1 VARCHAR(50) NOT NULL,
    zemlja2 VARCHAR(50) NOT NULL,
    accession_prot VARCHAR(100) NOT NULL,
    broj_razlika INT NOT NULL,
    PRIMARY KEY (mesec, godina, id_sekvence1, id_sekvence2, zemlja1, zemlja2, accession_prot)
);

DROP TABLE IF EXISTS percentage_results;

CREATE TABLE percentage_results (
	mesec SMALLINT NOT NULL,
	godina SMALLINT NOT NULL,
	zemlja1 VARCHAR(50) NOT NULL,
    zemlja2 VARCHAR(50) NOT NULL,
	accession_prot VARCHAR(100) NOT NULL,
	broj_razlika INT NOT NULL,
	percentage DECIMAL(5,2) NOT NULL,
	PRIMARY KEY (mesec, godina, zemlja1, zemlja2, accession_prot, broj_razlika)
);
