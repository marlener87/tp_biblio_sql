BEGIN;

CREATE TABLE IF NOT EXISTS `release` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `release` varchar(20) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

INSERT INTO `release`(`release`,`date`) VALUES ("1.0.0-0",now());

CREATE TABLE IF NOT EXISTS `emprunteur` (
  `numEmprunteur` int(11) NOT NULL AUTO_INCREMENT,
  `nomEmprunteur` varchar(255) NOT NULL,
  `adresseEmprunteur` text NOT NULL,
  `tel` int(11) NOT NULL,
  PRIMARY KEY (`numEmprunteur`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `editeur` (
  `numEditeur` int(11) NOT NULL AUTO_INCREMENT,
  `nomEditeur` varchar(255) NOT NULL,
  `adresseEditeur` text NOT NULL,
  PRIMARY KEY (`numEditeur`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `ouvrage` (
  `numOuvrage` int(11) NOT NULL AUTO_INCREMENT,
  `titre` varchar(255) NOT NULL,
  `numEditeur` int(11) NOT NULL,
  PRIMARY KEY (`numOuvrage`),
  CONSTRAINT `fk_numEditeur` FOREIGN KEY (`numEditeur`) REFERENCES `editeur`(`numEditeur`) /* Ajout d'un lien vers l'identifiant de l'editeur */
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `exemplaire` (
  `numExemplaire` int(11) NOT NULL AUTO_INCREMENT,
  `position` int(11) NOT NULL,
  `dateAchat` date NOT NULL,
  `numOuvrage` int(11) NOT NULL,
  PRIMARY KEY (`numExemplaire`),
  CONSTRAINT `fk_numOuvrage` FOREIGN KEY (`numOuvrage`) REFERENCES `ouvrage`(`numOuvrage`) -- Ajout d'un lien vers l'identifiant de l'ouvrage
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `emprunte` (
  `numExemplaire` int(11) NOT NULL,
  `numEmprunteur` int(11) NOT NULL,
  `dateEmprunt` date NOT NULL,
  `dateRetour` date,
  CONSTRAINT `fk_numEmprunteur` FOREIGN KEY (`numEmprunteur`) REFERENCES `emprunteur`(`numEmprunteur`), -- Ajout d'un lien vers l'identifiant de l'emprunteur
  CONSTRAINT `fk_numExemplaire` FOREIGN KEY (`numExemplaire`) REFERENCES `exemplaire`(`numExemplaire`) -- Ajout d'un lien vers l'identifiant de l'emprunteur
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/* Ajout d'une contrainte pour dateEmprunt <= dateRetour */
ALTER TABLE `emprunte` ADD CHECK (`dateEmprunt` <= `dateRetour`);

/* Ajout d'une contrainte pour que la date d'emprunt ne soit pas inférieure à la date d'achat */
DELIMITER $$
CREATE TRIGGER before_insert_checkdateAchat
BEFORE INSERT
ON emprunte FOR EACH ROW
BEGIN
    DECLARE dateAchatRecupere DATE;
    
    SELECT dateAchat 
    INTO dateAchatRecupere
    FROM exemplaire where numExemplaire = new.numExemplaire;
    
    IF dateAchatRecupere > new.dateEmprunt THEN
        SET NEW="Error: Impossible d'emprunter un livre dont la date d'achat est supérieure à la date d'emprunt.";
    END IF; 
END $$
DELIMITER ;

/* Ajout d'une contrainte pour qu'un exemplaire ne soit emprunté que par 1 seule personne à la fois */
DELIMITER $$
CREATE TRIGGER before_insert_checkExemplaireDispo 
BEFORE INSERT 
ON emprunte FOR EACH ROW
BEGIN 
    DECLARE rowcount INT;
    
    SELECT COUNT(*) INTO rowcount FROM emprunte where 
            numExemplaire = new.numExemplaire 
            and 
            ((dateEmprunt < new.dateEmprunt and new.dateEmprunt < dateRetour)
            or
            (new.dateEmprunt < dateEmprunt and dateEmprunt < new.dateRetour))
            ;
    
    IF rowcount != 0
        THEN 
        SET NEW="Error: Ce livre est déjà emprunté."; 
    END IF;    
END $$
DELIMITER ;


/* Ajout d'une contrainte pour qu'un livre ne soit emprunté que 14j, sinon retard */

DELIMITER $$
CREATE TRIGGER after_update_checkdateRetourOk 
AFTER UPDATE 
ON emprunte FOR EACH ROW
BEGIN 
    DECLARE dateEmpruntRecupere DATE;
    
    SELECT dateEmprunt INTO dateEmpruntRecupere FROM emprunte where numExemplaire = new.numExemplaire and numEmprunteur = new.numEmprunteur and dateEmprunt = new.dateEmprunt;
    
    IF new.dateRetour > (dateEmpruntRecupere + INTERVAL 14 DAY )
        THEN 
        SET NEW="Error: Le livre est rendu en retard."; 
    END IF;    
END $$
DELIMITER ;

COMMIT