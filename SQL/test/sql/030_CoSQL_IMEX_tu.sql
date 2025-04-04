/*
////
============================================================================== A
CoSQL_IMEX_tu.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_IMEX
Résumé : Tests unitaires du sous-composant CoSQL_IMEX du CoLOED.
Projet : CoSQL_2024-2
Responsable : Luc.Lavoie@USherbrooke.ca
Version : 103 (2024-08-12)
Statut : en cours de développement
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 14 à 16 (incl.)
============================================================================== A
*/

/*

Paramètres

1. Emplacement du répertoire d'exportation/importation

Déroulement

1. Créer une table à être exporter
2. L'initialiser adéquatement
3. L'exporter
4. Créer une table à être importée
5. En importer la valeur
6. Vérifier que la valeur exportée est égale à la valeur importée

*/

set schema 'CoSQL';

  /* TSTI */  select "test_identification" ('CoSQL_IMEX_tu', 'DÉBUT') ;

-- call "Parametre_interne_definir" ("parametre_importation" (), '/Users/Shared/DGS/CoLOED/SQL/temp/test/', 'Pour LL');
-- call "Parametre_interne_definir" ("parametre_exportation" (), '/Users/Shared/DGS/CoLOED/SQL/temp/test/', 'Pour LL');

-- call "Parametre_interne_affecter" ("parametre_importation" (), '/Users/Shared/DGS/CoLOED/SQL/temp/test/');
-- call "Parametre_interne_affecter" ("parametre_exportation" (), '/Users/Shared/DGS/CoLOED/SQL/temp/test/');


-- 1. Créer la table
drop table if exists IMEX_export;
create temporary table IMEX_export (
  no Integer,
  mes Text,
  b Boolean,
  q Numeric (12,4),
  x Double precision,
  t "Estampille"
);

-- 2. L'initialiser adéquatement
insert into IMEX_export values
  (1, 'premier', true, 15.1, 1.23456E+20, "estampille_min"()),
  (2, '2^e^ \!@#$%?&*()', false, 15.2, 2.23456E-20, now()),
  (3, '3''', true, 15.3, 3.23456E+20, "estampille_max"());
  -- select * from IMEX_export ;

-- 3. L'exporter
call "Exporter_par" ('select * from IMEX_export', 'IMEX.csv') ;

-- 4. Créer une table à être importée
drop table if exists IMEX_import;
create temporary table IMEX_import (
  like IMEX_export
);
  -- insert into IMEX_import (select * from IMEX_export) ;

-- 5. En importer la valeur
call "Importer_par" ('IMEX_import', 'IMEX.csv') ;

-- 6. Vérifier que la valeur exportée est égale à la valeur importée

call "Asserter" ('A:export-import réussi', "rel_ega_j" ('IMEX_import', 'IMEX_export')) ;
call "Asserter" ('A:export-import réussi', "rel_ega_d" ('IMEX_import', 'IMEX_export')) ;
call "Asserter" ('A:export-import réussi', "rel_ega" ('IMEX_import', 'IMEX_export')) ;
call "Manifester" ('M:export-import réussi', "rel_ega" ('IMEX_import', 'IMEX_export')) ;

drop table if exists IMEX_import;
drop table if exists IMEX_export;

  /* TSTI */  select "test_identification" ('CoSQL_IMEX_tu', 'FIN') ;

/*
============================================================================== Z
CoSQL_IMEX_tu.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoSQL_def.sql
============================================================================== Z
*/
