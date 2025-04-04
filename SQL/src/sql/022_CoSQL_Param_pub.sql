/*
////
============================================================================== A
CoSQL_Param_pub.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_Param
Résumé : Sous-composant paramétrage interne de l’environnement SQL commun du CoLOED.
Projet : CoSQL_2024-2
Responsable : Luc.Lavoie@USherbrooke.ca
Version : 103 (2024-08-12)
Statut : en cours de développement
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 14 à 16 (incl.)
============================================================================== A
*/

--
-- Entités publiques du composant
--

/*
////
Les routines du sous-composant CoSQL_Param permettent de gérer des paramètres
internes de la base de données dans laquelle le schéma "CoSQL" est défini.

Un paramètre est défini par trois valeurs de type Text : un identifiant, une valeur
et une annotation (considérée comme un commentaire explicatif quant à sa nature,
son rôle et sa portée).

Un paramètre peut être retiré (indéfini) sur la base de son identifiant.
On ne peut redéfinir un paramètre existant sans le retirer au préalable.
La valeur d’un paramètre défini peut être obtenue, modifiée ou affectée à
un autre paramètre déjà défini.
L’annotation d’un paramètre ne peut être modifiée.
Il faut retirer le paramètre et le redéfinir.
////
*/

create or replace procedure "Parametre_interne_definir"
  (
  z_parametre Text,
  z_valeur Text,
  z_annotation Text
  )
begin atomic
  insert into Parametre_interne(parametre, valeur, annotation)
    values (z_parametre, z_valeur, z_annotation) ;
end;
comment on procedure "Parametre_interne_definir" is $$
////
."Parametre_interne_definir" (z_parametre Text, z_valeur Text, z_annotation Text);

* Définir le paramètre, puis lui associer la valeur et l'annotation.
////
$$;

create or replace procedure "Parametre_interne_retirer"
  (
  z_parametre Text
  )
begin atomic
  delete from Parametre_interne where parametre = z_parametre;
end;
comment on procedure "Parametre_interne_retirer" is $$
////
."Parametre_interne_retirer" (z_parametre Text);

* Retirer le paramètre.
////
$$;

create or replace procedure "Parametre_interne_modifier"
  (
  z_parametre Text,
  z_valeur Text
  )
begin atomic
  update Parametre_interne
    set valeur = z_valeur
  where parametre = z_parametre ;
end;
comment on procedure "Parametre_interne_modifier" is $$
////
."Parametre_interne_modifier" (z_parametre Text, z_valeur Text);

* Affecter la valeur au paramètre.
////
$$;

create or replace procedure "Parametre_interne_copier"
  (
  z_source Text,
  z_destination Text
  )
begin atomic
  update Parametre_interne
    set valeur = (select valeur from Parametre_interne where parametre = z_source)
  where parametre = z_destination ;
end;
comment on procedure "Parametre_interne_copier" is $$
////
."Parametre_interne_copier" (z_source Text, z_destination Text);

* Affecter la valeur du paramètre source au paramètre destination.
////
$$;

create or replace function "Parametre_interne_valeur"
  (
  z_parametre Text
  )
returns Text
return
  (select valeur from Parametre_interne where parametre = z_parametre) ;
comment on function "Parametre_interne_valeur" is $$
////
."Parametre_interne_valeur" (z_source Text);

* Retourner la valeur du paramètre.
////
$$;

/*
============================================================================== Z
CoSQL_Param_pub.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoSQL_def.sql
============================================================================== Z
*/
