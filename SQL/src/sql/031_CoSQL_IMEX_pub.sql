/*
////
============================================================================== A
CoSQL_IMEX_pub.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_IMEX
Résumé : Sous-composant d’importation et d’exportation de l’environnement SQL commun du CoLOED.
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

=== Interfacte directe

Module TRÈS SIMPLE d’importation et d’exportation de tables à partir de fichiers
présents dans l’environnement du SGBD et présumés accessibles à ce dernier.

.Notes
Les fichiers importés et exportés sont présumés être au format .csv bien que
le délimiteur soit paramétrable. Le suffixe du nom de fichier n’est pas imposé
pour autant et doit conséquemment faire partie du nom.
Une généralisation pourrait être souhaitable.
////
*/

create or replace procedure "Importer"
  (z_nom_table Text, z_repertoire Text, z_fichier Text, z_delimiteur char default ',')
language plpgsql as
$$
begin
  execute
    format(
      'COPY %1$s FROM %2$L with (header, format csv, delimiter ''%3$s'')',
      z_nom_table,
      z_repertoire || z_fichier,
      z_delimiteur
    );
end;
$$;
comment on procedure "Importer" is $$
////
."Importer" (z_nom_table Text, z_repertoire Text, z_fichier Text, z_delimiteur char default ',');

* Les donnnées du fichier z_fichier localisé dans le répertoire z_repertoire
  seront versées dans la table _nom_table (au besoin le nom doit inclure le nom du schéma).
* Les données elles-mêmes y sont délimitées par le le symbole z_delimiteur
  (à défaut, la virgule).
* Le répertoire depuis lequel le fichier est importé est une chaine caractères
  en accord avec l’environnement d’exécution.
////
$$;

create or replace procedure "Exporter"
  (z_requete Text, z_repertoire Text, z_fichier Text, z_delimiteur char default ',')
language plpgsql as
$$
begin
  execute
    format(
      'COPY (%1$s) TO %2$L with (header, format csv, delimiter ''%3$s'')',
      z_requete,
      z_repertoire || z_fichier,
      z_delimiteur
    );
end;
$$;
comment on procedure "Exporter" is $$
////
."Exporter" (z_requete Text, z_repertoire Text, z_fichier Text, z_delimiteur char default ',');

* Les donnnées produite par la requête z_requête seront versées dans le fichier
   z_fichier localisé dans le répertoire z_repertoire.
* Les données elles-mêmes y seront délimitées par le le symbole z_delimiteur
  (à défaut, la virgule).
* Le répertoire depuis lequel le fichier est exporté est une chaine caractères
  en accord avec l’environnement d’exécution.
////
$$;

/*
============================================================================== Z
CoSQL_IMEX_pub.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoSQL_def.sql
============================================================================== Z
*/
