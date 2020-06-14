/* Detruire la bdd et l'utilisateur */
DROP DATABASE IF EXISTS bibliotheque;
DROP USER IF EXISTS 'bibliothequeusr'@'localhost';

/* Créer la bdd et l'utilisateur */
CREATE DATABASE bibliotheque;

CREATE USER 'bibliothequeusr'@'localhost' IDENTIFIED BY 'bibliothequepwd';
GRANT ALL PRIVILEGES ON bibliotheque.* TO 'bibliothequeusr'@'localhost';