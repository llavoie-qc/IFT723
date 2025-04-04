/*
////
============================================================================== A
CoSQL_Base_pub.obs.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_Base
Résumé : Éléments obsolètes du sous-composant CoSQL_Verif.
Projet : CoSQL_2024-2
Responsable : Luc.Lavoie@USherbrooke.ca
Version : 103 (2024-08-12)
Statut : en cours de développement
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 14 à 16 (incl.)
============================================================================== A
*/

set schema 'CoSQL';

/*
////
Le dialecte PostgreSQL antérieur à la version 11.4 n’offrait pas la
possibilité de définir des procédures conformément aux prescriptions de la norme
ISO 9075:2016. En lieu et place, une fonction pouvait être définie avec un
pseudo-type « void » et appelée par le biais de l’instruction « select ».

Ce dernier mécanisme est devenu redondant à partir de la version 11.4 qui
mit à disposition le mécanisme prévu par la norme (avec certaines erreurs,
il est vrai, qui ne seront corrigées qu’à partir de la version 14).
Depuis ce moment, les deux formes de procédures ont été offertes par de
nombreux modules de CoLOED (ou de ses ancêtres).

Les versions de PostgreSQL antérieures à 12 étant désormais caduques (non « supportées »),
les formes obsolètes ne sont plus nécessaires et seront définitivement retirées
au 2026-01-01.
Entretemps, afin de faciliter la transition des corpus de code non encore migrés,
le présent fichier permet de définir les formes désormais obsolètes.
////
*/

/*
////

* DEPRECATED 2024-07-25 (LL01) : void function "proc_assert"

////
*/

create or replace function "proc_assert"(
  message Text,
  ok Boolean
)
  returns Void
  volatile
  language "plpgsql" as
$$
begin
  if not ok then
    raise exception '*** %', ('ERR : ' || message) ;
  end if;
end
$$;

/*
////

* DEPRECATED 2024-07-25 (LL01) : void function "proc_manifest"

////
*/

create or replace function "proc_manifest"(
  message Text,
  ok Boolean
)
  returns Void
  volatile
  language "plpgsql" as
$$
declare
  b Boolean ;
begin
  b := "CoLOED"."test" (z_message, z_ok) ;
end
$$;

/*
////

* DEPRECATED 2024-07-25 (LL01) : void function "proc_assert_exception"

////
*/

create or replace function "proc_assert_exception"(
  message Text,
  instruction Text
)
  returns Void
  volatile
  language "plpgsql" as
$$
declare
  detection Boolean := true ;
begin
  execute instruction  ;
  detection := false ;
  raise exception 'toto' ;
exception
  when others then
    if not detection then
      raise exception '*** %', ('ERR : ' || message || ' -> ' || instruction) ;
    end if;
end
$$;

/*
////

* DEPRECATED 2024-07-25 (LL01) : void function "proc_manifest_exception"

////
*/

create or replace function "proc_manifest_exception"(
  message Text,
  instruction Text
)
  returns Void
  volatile
  language "plpgsql" as
$$
declare
  b Boolean ;
begin
  b := "CoSQL"."test_exception" (message, instruction) ;
end
$$;

/*
============================================================================== Z
CoSQL_Base_pub.obs.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoLOED_def.sql
============================================================================== Z
*/
