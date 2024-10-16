DROP PROCEDURE IF EXISTS CalculateUniquePercentage;

DELIMITER $$

CREATE PROCEDURE CalculateUniquePercentage()
BEGIN
    DECLARE country2 VARCHAR(100);
    DECLARE accession_prot_val VARCHAR(255);
    DECLARE total_serbian_seqs INT;
    DECLARE unique_seqs INT;
    DECLARE percentage DECIMAL(5,2);
    DECLARE done INT DEFAULT 0;

    DECLARE countries CURSOR FOR
        SELECT country FROM (SELECT 'grcka' AS country UNION SELECT 'hrvatska' UNION SELECT 'madjarska' UNION SELECT 'japan') AS countries;

    DECLARE proteins CURSOR FOR
        SELECT DISTINCT pks.accession_prot
        FROM protein_kod_sekv pks
        JOIN poravnato_clob pc ON pks.id = pc.id
        WHERE pc.country = 'srbija';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN countries;
    country_loop: LOOP
        FETCH countries INTO country2;
        IF done THEN
            SET done = 0;
            LEAVE country_loop;
        END IF;

        SELECT CONCAT('Processing country: ', country2) AS CurrentStatus;

        OPEN proteins;
        protein_loop: LOOP
            FETCH proteins INTO accession_prot_val;
            IF done THEN
                SET done = 0;
                LEAVE protein_loop;
            END IF;

            SELECT CONCAT('Processing protein: ', accession_prot_val) AS CurrentStatus;

            SET total_serbian_seqs = (SELECT COUNT(*)
                                      FROM poravnato_clob pc
                                      JOIN protein_kod_sekv pks ON pc.id = pks.id
                                      WHERE pc.country = 'srbija'
                                        AND pks.accession_prot = accession_prot_val);

            SELECT CONCAT('Total Serbian sequences: ', total_serbian_seqs) AS TotalSerbianSequences;

            SET unique_seqs = (SELECT COUNT(p1.kod_nuc)
                               FROM protein_kod_sekv p1
                               JOIN poravnato_clob pc1 ON p1.id = pc1.id
                               LEFT JOIN (
                                   SELECT p2.kod_nuc
                                   FROM protein_kod_sekv p2
                                   JOIN poravnato_clob pc2 ON p2.id = pc2.id
                                   WHERE pc2.country = country2
                               ) p2 ON p1.kod_nuc = p2.kod_nuc
                               WHERE pc1.country = 'srbija'
                                 AND p2.kod_nuc IS NULL
                                 AND p1.accession_prot = accession_prot_val);

            SELECT CONCAT('Unique sequences for ', country2, ': ', unique_seqs) AS UniqueSequences;

            IF total_serbian_seqs > 0 THEN
                SET percentage = (unique_seqs / total_serbian_seqs) * 100;
            ELSE
                SET percentage = 0;
            END IF;

            SELECT CONCAT('Percentage for ', country2, ' and ', accession_prot_val, ': ', percentage) AS Percentage;

            INSERT INTO unikatne_procenti_srbija (country, accession_prot, percentage)
            VALUES (country2, accession_prot_val, percentage);

        END LOOP protein_loop;
        CLOSE proteins;

    END LOOP country_loop;
    CLOSE countries;

END$$

DELIMITER ;

