/* Detruire la bdd et l'utilisateur */
DROP DATABASE bibliotest;
DROP USER 'marleneusr'@'localhost';


/* Créer la bdd et l'utilisateur */
CREATE DATABASE bibliotest;

CREATE USER 'marleneusr'@'localhost' IDENTIFIED BY 'marlenepwd';
GRANT ALL PRIVILEGES ON bibliotest.* TO 'marleneusr'@'localhost';