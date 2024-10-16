DROP PROCEDURE IF EXISTS Calc_identical;

DELIMITER //

CREATE PROCEDURE Calc_identical()
BEGIN
    DECLARE start_date DATE;
    DECLARE end_date DATE;
    DECLARE curr_date DATE;
    DECLARE curr_month INT;
    DECLARE curr_year INT;

    SET start_date = '2020-03-01';
    SET end_date = '2023-01-31';
    SET curr_date = start_date;

    WHILE curr_date < end_date DO
        SET curr_month = MONTH(curr_date);
        SET curr_year = YEAR(curr_date);

        INSERT INTO procenat_identicnih (country1, country2, month, percent)
        SELECT
            k.country1,
            k.country2,
            curr_month AS month,
            AVG(CASE WHEN p1.sequence = p2.sequence THEN 1 ELSE 0 END) * 100 AS percent
        FROM
            kombinacije_zemalja k
            JOIN sekvence p1 ON k.country1 = p1.country
            JOIN sekvence p2 ON k.country2 = p2.country
                             AND MONTH(p1.date) = curr_month
                             AND YEAR(p1.date) = curr_year
                             AND p1.id != p2.id
        GROUP BY
            country1,
            country2,
            month;

        SET curr_date = DATE_ADD(curr_date, INTERVAL 1 MONTH);
    END WHILE;

END //

DELIMITER ;

