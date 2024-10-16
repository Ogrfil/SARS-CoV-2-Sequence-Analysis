use sars_cov_2;

DROP TABLE IF EXISTS unikatne_procenti_srbija;

CREATE TABLE unikatne_procenti_srbija(
	country VARCHAR(100) NOT NULL,
	accession_prot VARCHAR(255) NOT NULL,
	percentage DECIMAL(5,2) NOT NULL,
	PRIMARY KEY (country,accession_prot)
);
