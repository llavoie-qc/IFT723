/*
////
============================================================================== A
CoSQL_Base_tu.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_Base
Résumé : Tests unitaires de CoSQL_Base.
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

  /* TSTI */  select "test_identification" ('CoSQL_Base_tu', 'DÉBUT') ;

call "Asserter" ('#1 : "entier_min"() < "entier_min"() + 1',
  "entier_min"() < "entier_min"() + 1) ;
call "Asserter" ('#2 : "entier_max"() - 1 < "entier_max"()',
  "entier_max"() - 1 < "entier_max"()) ;
call "Asserter_exception" ('#3 : "entier_min"() - 1 doit lever une exception',
  'select cast ("entier_min"() - 1 as "Entier")') ;
call "Asserter_exception" ('#4 : "entier_max"() + 1 doit lever une exception',
  'select cast ("entier_max"() + 1 as "Entier")') ;

call "Asserter" ('#1 : "cardinal_min"() < "cardinal_min"() + 1',
  "cardinal_min"() < "cardinal_min"() + 1) ;
call "Asserter" ('#2 : "cardinal_max"() - 1 < "cardinal_max"()',
  "cardinal_max"() - 1 < "cardinal_max"()) ;
call "Asserter_exception" ('#3 : "cardinal_min"() - 1 doit lever une exception',
  'select cast ("cardinal_min"() - 1 as "Cardinal")') ;
call "Asserter_exception" ('#4 : "cardinal_max"() + 1 doit lever une exception',
  'select cast ("cardinal_max"() + 1 as "Cardinal")') ;

call "Asserter" ('#1 : "ordinal_min"() < "ordinal_min"() + 1',
  "ordinal_min"() < "ordinal_min"() + 1) ;
call "Asserter" ('#2 : "ordinal_max"() - 1 < "ordinal_max"()',
  "ordinal_max"() - 1 < "ordinal_max"()) ;
call "Asserter_exception" ('#3 : "ordinal_min"() - 1 doit lever une exception',
  'select cast ("ordinal_min"() - 1 as "Ordinal")') ;
call "Asserter_exception" ('#4 : "ordinal_max"() + 1 doit lever une exception',
  'select cast ("ordinal_max"() + 1 as "Ordinal")') ;

call "Asserter" ('#1 : "estampille_min"() < "estampille_min"() + "estampille_chronon"()',
  "estampille_min"() < "estampille_min"() + "estampille_chronon"()) ;
call "Asserter" ('#2 : "estampille_max"() - "estampille_chronon"() < "estampille_max"()',
  "estampille_max"() - "estampille_chronon"() < "estampille_max"()) ;
call "Asserter_exception" ('#3 : ("estampille_min"() - "estampille_chronon"())::"Estampille" doit lever une exception',
  'select cast ("estampille_min"() - "estampille_chronon"() to "Estampille")') ;
call "Asserter_exception" ('#4 : "estampille_max"() + "estampille_chronon"() doit lever une exception',
  'select "estampille_max"() + "estampille_chronon"()') ;
call "Asserter" ('#5 : "estampille_chronon"() * "estampille_ncs"() = 1 seconde',
  "estampille_chronon"() * "estampille_ncs"() = interval '1.0') ;

  /* TSTI */  select "test_identification" ('CoSQL_Base_tu', 'FIN') ;

/*
////
.FIXED 2023-07-27 (LL01) Test Estampille #2 est hors borne sous psql, mais pas sous Datagrip
  * Selon la documentation, il ne devrait pas y avoir d’erreur.
  * Voir https://www.postgresql.org/docs/16/datatype-datetime.html (inchangé de v12 à v16)
  * CORRECTION
    - À cause du décalage horaire implicite lors des conversions implicites entre
      Timestamp et Timestamp with time zone, il faut toujours opérer une conversion
      explicite en utilisant l’opérateur cast. C’est désormais le cas.

.FIXED 2023-07-27 (LL01) Test Estampille #3 concluant sous psql, mais pas sous DataGrip.
  * L’expression `"estampille_min"() - "estampille_chronon"()` doit lever une exception.
  * CORRECTION
  - À cause du -infinity, la détection échoue tant que la valeur n’est pas affectée
    à une variable de type Estampille. Elle ne le sera pas si elle est affectée à
    une variable de type Timestamp (indépendamment de la présence ou non du time zone).
  - Le test a donc été modifié afin d'évaluer l'expression suivante  :
      `cast ("estampille_min"() - "estampille_chronon"() to "Estampille")`
////
*/

/*
============================================================================== Z
CoSQL_Base_tu.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoSQL_def.sql
============================================================================== Z
*/
