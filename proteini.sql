use sars_cov_2;
DROP PROCEDURE IF EXISTS otvori_cursor;
DELIMITER $$
CREATE PROCEDURE otvori_cursor(rbr_val int, id_val VARCHAR(255), aligned_seq TEXT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE accession_prot_val VARCHAR(255);
    DECLARE protein_val VARCHAR(50);
    DECLARE leva_granica_val INT;
    DECLARE desna_granica_val INT;
    DECLARE broj_leva INT DEFAULT 0;
    DECLARE broj_izmedju INT DEFAULT 0;
    DECLARE aligned_seq_ref TEXT; 
    DECLARE temp TEXT; 
    DECLARE cur_prot CURSOR FOR
        SELECT accession_prot, protein, leva_granica, desna_granica
        FROM granice_proteini;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    SET aligned_seq_ref = (
    	SELECT r.aligned_sequence
    	FROM poravnato_clob_ref as r
    	WHERE r.rbr = rbr_val);
    
    OPEN cur_prot;
    read_loop: LOOP
        FETCH cur_prot INTO accession_prot_val, protein_val, leva_granica_val, desna_granica_val;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET temp = SUBSTRING(aligned_seq_ref, 1, leva_granica_val-1);
        SET broj_leva = LENGTH(temp) - LENGTH(REPLACE(temp, '_', ''));
        SET leva_granica_val = leva_granica_val + broj_leva;
        
        SET temp = SUBSTRING(aligned_seq_ref, leva_granica_val, desna_granica_val - leva_granica_val + 1);
        SET broj_izmedju = LENGTH(temp) - LENGTH(REPLACE(temp, '_', ''));
        SET desna_granica_val = desna_granica_val + broj_leva + broj_izmedju;

        INSERT INTO protein_kod_sekv (id, accession_prot, protein, leva_granica, desna_granica, duzina_nuc, kod_nuc)
        SELECT id_val, granice_proteini.accession_prot, granice_proteini.protein,leva_granica_val,desna_granica_val, desna_granica_val - leva_granica_val + 1, SUBSTRING(aligned_seq, leva_granica_val, desna_granica_val - leva_granica_val + 1)
        FROM granice_proteini
        WHERE desna_granica_val <= LENGTH(aligned_seq) 
        AND granice_proteini.accession_prot = accession_prot_val;
    END LOOP;
    CLOSE cur_prot;
END$$
DELIMITER ;



DROP PROCEDURE IF EXISTS pronadji_proteine;
DELIMITER $$
CREATE PROCEDURE pronadji_proteine()
BEGIN
    DECLARE rbr_val INT;
    DECLARE id_val VARCHAR(255);
    DECLARE aligned_seq TEXT;
    DECLARE len_val INT;
    DECLARE leva_granica INT;
    DECLARE desna_granica INT;
    DECLARE protein_val VARCHAR(50);
    DECLARE done INT DEFAULT FALSE;

    DECLARE cur CURSOR FOR
    	SELECT rbr, id, aligned_sequence FROM poravnato_clob;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO rbr_val, id_val, aligned_seq;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        CALL otvori_cursor(rbr_val, id_val, aligned_seq);

    END LOOP;

    CLOSE cur;
END$$
DELIMITER ;

