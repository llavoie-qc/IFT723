/*
////
============================================================================== A
CoSQL_Base_co.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_Base
Résumé : Constat du sous-composant CoSQL_Base.
Projet : CoSQL_2024-2
Responsable : Luc.Lavoie@USherbrooke.ca
Version : 103 (2024-08-12)
Statut : en cours de développement
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 14 à 16 (incl.)
============================================================================== A
*/

set schema 'CoSQL';
set time zone 'UTC' ;

  /* TSTI */  select "test_identification" ('CoSQL_Base_co', 'DÉBUT') ;

select
  "test_identification" ('CoSQL_Base_co', 'A. Propriétés entières'),
  "entier_min"(),
  "entier_max"() ;

select
  "test_identification" ('CoSQL_Base_co', 'B. Propriétés cardinales'),
  "cardinal_min"(),
  "cardinal_max"() ;

select
  "test_identification" ('CoSQL_Base_co', 'C. Propriétés ordinales'),
  "ordinal_min"(),
  "ordinal_max"() ;

select
  "test_identification" ('CoSQL_Base_co', 'D. Propriétés temporelles'),
  extract (epoch from "estampille_chronon"()),
  "estampille_ncs"(),
  "estampille_min"(),
  "estampille_max"() ;
call "Manifester_exception" ('#3 : ("estampille_min"() - "estampille_chronon"())::"Estampille" doit lever une exception',
  'select ("estampille_min"() - "estampille_chronon"()::"Estampille")') ;
call "Manifester_exception" ('#3 : ("estampille_min"() - "estampille_chronon"())" doit AUSSI lever une exception',
  'select ("estampille_min"() - "estampille_chronon"())') ;

  /* TSTI */  select "test_identification" ('CoSQL_Base_co', 'FIN') ;

/*
============================================================================== Z
CoSQL_Base_co.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoSQL_def.sql
============================================================================== Z
*/
