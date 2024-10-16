DROP PROCEDURE IF EXISTS CalculateDifferent;

DELIMITER $$

CREATE PROCEDURE CalculateDifferent()
BEGIN
    DECLARE start_date DATE DEFAULT '2020-03-01';
    DECLARE end_date DATE DEFAULT '2023-01-31';
    DECLARE curr_date DATE;
    DECLARE country1_val VARCHAR(100);
    DECLARE country2_val VARCHAR(100);
    DECLARE accession_prot_val VARCHAR(255);
    DECLARE seq1 TEXT;
    DECLARE seq2 TEXT;
    DECLARE diff_count INT;
    DECLARE i INT;
    DECLARE id1 VARCHAR(255);
    DECLARE id2 VARCHAR(255);
    DECLARE done INT DEFAULT 0;
    DECLARE done1 INT DEFAULT 0;
    DECLARE done2 INT DEFAULT 0;
    
    DECLARE cur_combinations CURSOR FOR
        SELECT country1, country2
        FROM kombinacije_zemalja;

    DECLARE cur_proteins CURSOR FOR
        SELECT DISTINCT accession_prot
        FROM protein_kod_sekv;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SET curr_date = start_date;

    WHILE curr_date <= end_date DO
        SET @date_ = curr_date;

        SELECT CONCAT('Processing month: ', MONTH(@date_), ', year: ', YEAR(@date_)) AS datum;

        OPEN cur_combinations;
        combination_loop: LOOP
            FETCH cur_combinations INTO country1_val, country2_val;
            IF done THEN
                SET done = 0;
                LEAVE combination_loop;
            END IF;

            IF country1_val = country2_val THEN
                ITERATE combination_loop;
            END IF;

            SELECT CONCAT('Processing country pair: ', country1_val, '-', country2_val) AS countries;

            OPEN cur_proteins;
            protein_loop: LOOP
                FETCH cur_proteins INTO accession_prot_val;
                IF done THEN
                    SET done = 0;
                    LEAVE protein_loop;
                END IF;

                SELECT CONCAT('Processing protein: ', accession_prot_val) AS protein;

                BEGIN
                    DECLARE done1 INT DEFAULT 0;
                    DECLARE cur_seq1 CURSOR FOR
                        SELECT pks.id, pks.kod_nuc
                        FROM protein_kod_sekv pks
                        JOIN poravnato_clob pc ON pks.id = pc.id
                        WHERE pc.country = country1_val AND MONTH(pc.date) = MONTH(@date_) AND YEAR(pc.date) = YEAR(@date_) AND pks.accession_prot = accession_prot_val;

                    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done1 = 1;

                    OPEN cur_seq1;
                    seq1_loop: LOOP
                        FETCH cur_seq1 INTO id1, seq1;
                        IF done1 THEN
                            SET done1 = 0;
                            LEAVE seq1_loop;
                        END IF;

                        BEGIN
                            DECLARE done2 INT DEFAULT 0;
                            DECLARE cur_seq2 CURSOR FOR
                                SELECT pks.id, pks.kod_nuc
                                FROM protein_kod_sekv pks
                                JOIN poravnato_clob pc ON pks.id = pc.id
                                WHERE pc.country = country2_val AND MONTH(pc.date) = MONTH(@date_) AND YEAR(pc.date) = YEAR(@date_) AND pks.accession_prot = accession_prot_val;

                            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done2 = 1;

                            OPEN cur_seq2;
                            seq2_loop: LOOP
                                FETCH cur_seq2 INTO id2, seq2;
                                IF done2 THEN
                                    SET done2 = 0;
                                    LEAVE seq2_loop;
                                END IF;

                                SET diff_count = 0;
                                SET @len = LENGTH(seq1);
                                SET i = 1;
                                WHILE i <= @len DO
                                    IF SUBSTRING(seq1, i, 1) != SUBSTRING(seq2, i, 1) THEN
                                        SET diff_count = diff_count + 1;
                                    END IF;
                                    SET i = i + 1;
                                END WHILE;
								SELECT CONCAT(id1,' - ', id2) AS ids;
                                INSERT INTO razlike_proteina (mesec, godina, id_sekvence1, id_sekvence2, zemlja1, zemlja2, accession_prot, broj_razlika)
                                VALUES (MONTH(@date_), YEAR(@date_), id1, id2, country1_val, country2_val, accession_prot_val, diff_count);

                            END LOOP seq2_loop;
                            CLOSE cur_seq2;

                        END;

                    END LOOP seq1_loop;
                    CLOSE cur_seq1;

                END;

            END LOOP protein_loop;
            CLOSE cur_proteins;

        END LOOP combination_loop;
        CLOSE cur_combinations;

        SET curr_date = DATE_ADD(curr_date, INTERVAL 1 MONTH);
    END WHILE;
END$$

DELIMITER ;

DELIMITER ;

DROP PROCEDURE IF EXISTS CalculatePercentage;

DELIMITER $$

CREATE PROCEDURE CalculatePercentage()
BEGIN
    DECLARE curr_month SMALLINT;
    DECLARE curr_year SMALLINT;
    DECLARE curr_prot VARCHAR(100);
    DECLARE country1 VARCHAR(100);
    DECLARE country2 VARCHAR(100);
    DECLARE total_rows INT;
    DECLARE same_diff_rows INT;
    DECLARE percentage DECIMAL(5,2);
    DECLARE broj_razlika_val INT;

    DECLARE done INT DEFAULT 0;

    DECLARE cur_combinations CURSOR FOR
    SELECT DISTINCT mesec, godina, accession_prot, zemlja1, zemlja2
    FROM razlike_proteina;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur_combinations;
    combination_loop: LOOP
        FETCH cur_combinations INTO curr_month, curr_year, curr_prot, country1, country2;
        IF done THEN
            SET done = 0;
            LEAVE combination_loop;
        END IF;

        SET total_rows = (SELECT COUNT(*)
                          FROM razlike_proteina
                          WHERE mesec = curr_month
                          AND godina = curr_year
                          AND accession_prot = curr_prot
                          AND zemlja1 = country1
                          AND zemlja2 = country2);

        IF total_rows = 0 THEN
            ITERATE combination_loop;
        END IF;

        BEGIN
        	DECLARE done_diffs INT DEFAULT 0;
            DECLARE cur_diffs CURSOR FOR
            SELECT DISTINCT broj_razlika
            FROM razlike_proteina
            WHERE mesec = curr_month AND godina = curr_year AND accession_prot = curr_prot AND zemlja1 = country1 AND zemlja2 = country2;

            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_diffs = 1;

            OPEN cur_diffs;
            diff_loop: LOOP
                FETCH cur_diffs INTO broj_razlika_val;
                IF done_diffs THEN
                    SET done_diffs = 0;
                    LEAVE diff_loop;
                END IF;

                SET same_diff_rows = (SELECT COUNT(*)
                                      FROM razlike_proteina
                                      WHERE mesec = curr_month 
                                      AND godina = curr_year 
                                      AND accession_prot = curr_prot 
                                      AND zemlja1 = country1 
                                      AND zemlja2 = country2 
                                      AND broj_razlika = broj_razlika_val);

                SET percentage = (same_diff_rows / total_rows) * 100;

                SELECT CONCAT('br_razlika ', broj_razlika_val, ' total_rows ', total_rows, ' same_diff_rows ', same_diff_rows, ' percentage ', percentage) as info;

                INSERT INTO percentage_results (mesec, godina, accession_prot, zemlja1, zemlja2, broj_razlika, percentage) 
                VALUES (curr_month, curr_year, curr_prot, country1, country2, broj_razlika_val, percentage);

            END LOOP diff_loop;
            CLOSE cur_diffs;
        END;

    END LOOP combination_loop;
    CLOSE cur_combinations;

END$$

DELIMITER ;


