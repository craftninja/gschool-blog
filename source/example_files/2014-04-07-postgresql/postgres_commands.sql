CREATE DATABASE delicious_scotch;
\c delicious_scotch
CREATE TABLE scotch
(id SERIAL PRIMARY KEY,
name CHARACTER VARYING(255),
region CHARACTER VARYING(255),
flavour CHARACTER VARYING(255),
age INTEGER,
price NUMERIC);
INSERT INTO scotch(name, region, flavour, age, price)
VALUES ('Talisker', 'Islay', 'full-bodied and smokey', 10, 65);
INSERT INTO scotch(name, region, flavour, age, price)
VALUES ('Lagavulin', 'Islaay', 'full-bodied and smokey', 16, 80);
INSERT INTO scotch(name, region, flavour, age, price)
VALUES ('Knockando', 'Speyside', 'fruity and delicate', 12, 50);
INSERT INTO scotch(name, region, flavour, age, price)
VALUES ('Ardbeg', 'Islay', 'full-bodied and smokey', 10, 60);
SELECT * FROM scotch;
UPDATE scotch SET region='Islay' WHERE id=3;
DELETE FROM scotch WHERE id=3;
SELECT * FROM scotch;
DROP TABLE scotch;
\c postgres
DROP DATABASE delicious_scotch;
\l
\q
