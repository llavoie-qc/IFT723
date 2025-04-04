/*
////
============================================================================== A
CoSQL_Base_pub-rel.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_Base
Résumé : Extension CoSQL_Base_pub permettant de tester l'égalité de deux relations.
Projet : CoSQL_2024-2
Responsable : Luc.Lavoie@USherbrooke.ca
Version : 103 (2024-08-12)
Statut : en cours de développement
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 14 à 16 (incl.)
============================================================================== A
*/

/*
////
=== Relations

La fonction "rel_ega" est un palliatif à l’absence de l’opérateur d’égalité
entre deux relations (tables) en SQL. Chaque table à comparer y est désignée
par une valeur de type Text représentant la dénotation complète de la table
comme prescrit par la norme ISO 9075:2016
(préfixation l’identifiant du schéma ou non, identifiants simples ou délimités, etc.).
////
*/

create or replace function "rel_ega_j"
  (z_t1 Text, z_t2 Text)
  returns Boolean
  volatile
  language plpgsql as
$$
declare
  b Boolean ;
begin
  execute
    format ('
      with
        A as (select count(*) as nb from %1$s),
        B as (select count(*) as nb from %2$s),
        J as (select count(*) as nb from %1$s natural join %2$s)
      select
            (select nb from J) = (select nb from A)
        and (select nb from J) = (select nb from B) as egal',
      z_t1,
      z_t2
    )
  into b;
  return b;
end
$$;

create or replace function "rel_ega_d"
  (z_t1 Text, z_t2 Text)
  returns Boolean
  volatile
  language plpgsql as
$$
declare
  b Boolean ;
begin
  execute
    format ('
      with
        A as (select * from %1$s except select * from %2$s),
        B as (select * from %2$s except select * from %1$s)
      select
            not exists (select * from A)
        and not exists (select * from B) as egal',
      z_t1,
      z_t2
    )
  into b;
  return b;
end
$$;

create or replace function "rel_ega"
  (z_t1 Text, z_t2 Text)
  returns Boolean
  volatile
return
  "rel_ega_j" (z_t1, z_t2) ;
comment on function "rel_ega" is $$
////
."rel_ega" (z_t1 Text, z_t2 Text) : Boolean;

* Soit deux tables de même type, la fonction détermine si elles sont égales
  au sens relationnel du terme.
* Deux tables sont du même type si elles partagent exactement les mêmes attributs
  (mêmes identifiants des mêmes types).
* Deux tables sont égales au sens relationnel si elles sont composées exactement
  des mêmes tuples.
* Rappel : les tables représentant ici des relations sont des ensembles.
  Elles ne peuvent donc pas comprendre de tuples en double.
////
$$;

/*
////
.Note de mise en oeuvre

* La définition de "rel_ega" a été séparée des autres définitions du sous-composant
  CoSQL_Base, car sa mise en oeuvre fait appel à la commande EXECUTE de SQL.
  Dans plusieurs contextes (pour des raisons de sécurité, de vérifiabilité, etc.),
  le recours à cette commande est proscrit. En séparant cette définition des autres,
  il est plus facile d’inclure ces dernières sans déroger aux prescriptions.

.TOIMPROVE 2024-08-06 (LL01) Optimisation possible de "rel_ega" ?
  * Il serait approprié de déterminer si la mise en oeuvre par double différence
    est plus efficiente celle par jointure présentement utilisée.
////
*/

/*
============================================================================== Z
CoSQL_Base_pub-rel.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoSQL_def.sql
============================================================================== Z
*/
