/*
-- =========================================================================== A
Produit : CoFELI:Exemple/Sondage
Trimestre : 2024-1
Composant : Sondage_jdd-inv.sql (solution)
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 9.4 à 16.2
Responsables : Christina.KHNAISSER@USherbrooke.ca ; Luc.LAVOIE@USherbrooke.ca
Version : 0.1.1a
Statut : solution préliminaire
-- =========================================================================== A
*/

SET SCHEMA 'Sondage' ;

/*
-- =========================================================================== B
Les préfixes de ligne "-- xox" sont destinés à être remplacés par des
instructions d’écriture lorsque le fichier est exécuté sous forme de script.
Par exemple,
  - "prompt " sous SQL*Plus (Oracle),
  - "\echo  " sous psql (PostgreSQL).
-- =========================================================================== B
*/

-- x0x "=====================================================================" ;
-- x0x "Insertionss de données invalides" ;
-- x0x "=====================================================================" ;

-- x0x "Insertions dans Questionnaire"
  -- Numéro du questionnaire ne peut pas dépasser 7 caractères
INSERT INTO Questionnaire(idQ, titre, auteur, dateDebut, dateFin) VALUES
  ('Q000002xx', 'IFT187 - Semaine 1 : Les colles du prof', 'Christina Khnaisser', '2015-08-31', '2015-09-07');
  -- Date de fin est plus petite que la date de début
INSERT INTO Questionnaire(idQ, titre, auteur, dateDebut, dateFin) VALUES
  ('Q000001', 'IFT187 - Semaine 0 : Les colles du prof', 'Luc Lavoie', '2015-08-24', '2015-08-18');
  -- Numéro du questionnaire existe
INSERT INTO Questionnaire(idQ, titre, auteur, dateDebut, dateFin) VALUES
  ('Q000001', 'IFT187 - Semaine 0 : Les colles du prof', 'Luc Lavoie', '2015-08-18', '2015-08-24');


-- x0x "Insertions dans Question"
  -- Numéro de la question dépasse 9999
INSERT INTO Question (noQ, idQ, libelle, typeQ, obligatoire) VALUES
  (10000, 'Q000001', 'Nom', 'QO', 'f');
  -- Type de question n'est pas dans le domaine de valeur défini
INSERT INTO Question (noQ, idQ, libelle, typeQ, obligatoire) VALUES
  (2, 'Q000001', 'Prenom', 'xxx', 'f');


-- x0x "Insertions dans ChoixQCM"
    -- Le questionnaire n'existe pas
INSERT INTO ChoixQCM (idQ, noQ, noChoix, description) VALUES
  ('Q000008', 5, 1, '1');
   -- La question n'existe pas dans le questionnaire
INSERT INTO ChoixQCM (idQ, noQ, noChoix, description) VALUES
  ('Q000001', 10, 1, '2');


-- x0x "Insertions dans Repondant" ;
  -- Matricule contient des lettres
INSERT INTO Repondant (matricule, nom, prenom, courriel) VALUES
  ('CKAH7627', 'Madi', 'Adelle', 'Adelle.Madi@usherbrooke.ca');
  -- Matricule contient plus que 8 chiffres
INSERT INTO Repondant (matricule, nom, prenom, courriel) VALUES
  ('1827461524', 'Toto', 'Boulot', 'Toto.Boulot@usherbrooke.ca');


-- x0x "Insertions dans Formulaire"
 -- Le questionnaire n'existe pas
INSERT INTO Formulaire (idQ, matricule, dateReponse) VALUES
  ('Q000011', '01957627', '2015-08-20');
 -- Le répondant n'existe pas
INSERT INTO Formulaire (idQ, matricule, dateReponse) VALUES
  ('Q000001', '09999997', '2015-08-20');

-- x0x "Insertions dans Reponse"
  -- Les répondant n'existe pas
INSERT INTO Reponse (idQ, matricule, noQ) VALUES
  ('Q000001', '09999997', 1);
  -- Le questionnaire n'existe pas
INSERT INTO Reponse (idQ, matricule, noQ) VALUES
  ('Q000011', '01957627', 2);
  -- La question pour le questionnaire n'existe pas
INSERT INTO Reponse (idQ, matricule, noQ) VALUES
  ('Q000001', '01957627', 10);

-- x0x "Insertions dans RO"

-- x0x "Insertions dans RCM"
 -- Le numéro du choix pour la question n'existe pas
INSERT INTO RCM (idQ, matricule, noQ, noChoix) VALUES
  ('Q000001', '01957627', 5, 4);
  -- Les répondant n'existe pas
INSERT INTO RCM (idQ, matricule, noQ, noChoix) VALUES
  ('Q000001', '09999997', 5, 1);
  -- Le questionnaire n'existe pas
INSERT INTO RCM (idQ, matricule, noQ, noChoix) VALUES
  ('Q000011', '01957627', 5, 1);
  -- Répondant n'a pas répondu à la question 7 (Voir données Reponse)
INSERT INTO RCM (idQ, matricule, noQ, noChoix) VALUES
  ('Q000001', '01957627', 7, 3);

/*
-- =========================================================================== Z
.Contributeurs :
  (CK01) Christina.KHNAISSER@USherbrooke.ca,
  (LL01) Luc.LAVOIE@USherbrooke.ca

.Adresse, droits d’auteur et copyright :
  Groupe Groupe Μῆτις (Métis)
  Département d’informatique
  Faculté des sciences
  Université de Sherbrooke
  Sherbrooke (Québec)  J1K 2R1
  Canada

  [CC-BY-NC-4.0 (http://creativecommons.org/licenses/by-nc/4.0)]

.Tâches projetées :
  S.O.

.Tâches réalisées :
  * 2024-04-04 (LL01) : Restructuration pour intégration à CoFELI
    - Changement de noms, élimination des fichiers doublons
  * 2022-01-10 (LL01) : Diverses corrections de coquilles
    - Uniformisation des commentaires
  * 2015-09-14 (LL01) : Revue.
  * 2015-08-20 (CK01) : Création initiale.

.Références :
  * [epp] CoFELI:Exemples/Sondage/Sondage_DDV.pdf
  * [std] Akademia:Modules/BD190-STD-SQL-01_NDC.pdf

-- -----------------------------------------------------------------------------
-- fin de Sondage_jdd-inv.sql
-- =========================================================================== Z
*/
