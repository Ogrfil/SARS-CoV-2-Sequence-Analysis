DROP TABLE IF EXISTS lcs_srbija_japan;

CREATE TABLE lcs_srbija_japan(
	start_date date NOT NULL,
	end_date date NOT NULL,
	leva_granica int NOT NULL,
	desna_granica int NOT NULL,
	lcs TEXT NOT NULL,
	PRIMARY KEY (start_date,end_date)
);
