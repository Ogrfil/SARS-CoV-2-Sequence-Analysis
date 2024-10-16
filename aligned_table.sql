use sars_cov_2;

DROP TABLE IF EXISTS poravnato_clob;
DROP TABLE IF EXISTS poravnato_clob_ref;

CREATE TABLE poravnato_clob (
	rbr smallint NOT NULL,
    id VARCHAR(255) NOT NULL,
    accession_id VARCHAR(255) NOT NULL,
    country VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    aligned_sequence TEXT NOT NULL,
    len integer NOT NULL,
    PRIMARY KEY (rbr,id)
);

CREATE TABLE poravnato_clob_ref (
	rbr smallint NOT NULL,
    id VARCHAR(255) NOT NULL,
    aligned_sequence TEXT NOT NULL,
    len integer NOT NULL,
    PRIMARY KEY (rbr,id)
);
