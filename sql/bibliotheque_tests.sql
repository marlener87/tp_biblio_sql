/* Requêtes de test */
truncate TABLE emprunte; -- efface le contenu de la table
INSERT INTO `emprunte`(`numExemplaire`, `numEmprunteur`, `dateEmprunt`, `dateRetour`) VALUES (1,1,"2020-05-10","2020-05-12"); -- insère le 1er emprunt

INSERT INTO `emprunte`(`numExemplaire`, `numEmprunteur`, `dateEmprunt`, `dateRetour`) VALUES (1,1,"2020-05-08","2020-05-11"); -- test d'insertion d'un nouvel emprunt du même exemplaire, provoque une erreur

INSERT INTO `emprunte`(`numExemplaire`, `numEmprunteur`, `dateEmprunt`, `dateRetour`) VALUES (1,1,"2020-05-11","2020-05-13"); -- test d'insertion d'un nouvel emprunt du même exemplaire, provoque une erreur

INSERT INTO `emprunte`(`numExemplaire`, `numEmprunteur`, `dateEmprunt`, `dateRetour`) VALUES (1,1,"2020-05-13","2020-05-14"); -- test d'insertion d'un nouvel emprunt du même exemplaire, fonctionne et insère un 2nd emprunt


/* Requetes SQL pour tester les contraintes */

-- Erreur car numExemplaire et numEmprunteur n'existent pas:
INSERT INTO `emprunte`(`numExemplaire`, `numEmprunteur`, `dateEmprunt`, `dateRetour`) VALUES (1,1,"2020-05-12","2020-05-10");

-- Erreur car numOuvrage n'existe pas:
INSERT INTO `exemplaire`(`numExemplaire`, `position`, `dateAchat`, `numOuvrage`) VALUES (1,1,"2020-01-01",1);

-- Erreur car numEditeur n'existe pas:
INSERT INTO `ouvrage`(`numOuvrage`, `titre`, `numEditeur`) VALUES (1,"SQL par l'exemple",1);


-- Creation numEditeur, numOuvrage, numEmprunteur
INSERT INTO `editeur`(`numEditeur`, `nomEditeur`, `adresseEditeur`) VALUES (1,"Eyrolle", "Boulevard des livres");
INSERT INTO `ouvrage`(`numOuvrage`, `titre`, `numEditeur`) VALUES (1,"SQL par l'exemple",1);
INSERT INTO `emprunteur`(`numEmprunteur`, `nomEmprunteur`, `adresseEmprunteur`, `tel`) VALUES (1,"marlene","rue picpus","0000000000");
INSERT INTO `exemplaire`(`numExemplaire`, `position`, `dateAchat`, `numOuvrage`) VALUES (1,1,"2020-01-01",1);
INSERT INTO `emprunte`(`numExemplaire`, `numEmprunteur`, `dateEmprunt`, `dateRetour`) VALUES (1,1,"2019-05-10","2020-05-12");

INSERT INTO `emprunte`(`numExemplaire`, `numEmprunteur`, `dateEmprunt`, `dateRetour`) VALUES (1,1,"2020-05-12","2020-05-10");



INSERT INTO `emprunte`(`numExemplaire`, `numEmprunteur`, `dateEmprunt`, `dateRetour`) VALUES (1, 1,2020-05-23, 2020-06-15)