use sars_cov_2;

DROP TABLE IF EXISTS sekvence;
DROP TABLE IF EXISTS procenat_identicnih;


CREATE TABLE sekvence(
	i int NOT NULL PRIMARY KEY AUTO_INCREMENT,
	id VARCHAR(255) NOT NULL,
    accession_id VARCHAR(255) NOT NULL,
    country VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    sequence TEXT NOT NULL,
    len integer NOT NULL
);

CREATE TABLE procenat_identicnih(
	country1 VARCHAR(100) NOT NULL,
	country2 VARCHAR(100) NOT NULL,
	month smallint NOT NULL,
	year smallint NOT NULL,
	percent float NOT NULL,
	PRIMARY KEY (country1,country2,month,year)
);
