DROP TABLE IF EXISTS kombinacije_zemalja;

CREATE TABLE kombinacije_zemalja AS
SELECT DISTINCT p1.country AS country1, p2.country AS country2
FROM poravnato_clob p1
CROSS JOIN poravnato_clob p2
WHERE p1.country < p2.country;

