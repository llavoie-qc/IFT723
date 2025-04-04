/*
////
============================================================================== A
CoSQL_IMEX_pub-par.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_IMEX
Résumé : Extension pour le paramétrage du sous-composant CoSQL_IMEX.
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

=== Interface paramétrée

Sous-composant offrant l’importation de fichiers [et l’exportation de tables]
à partir [au droit] de l’environnement du SGBD depuis le répertoire désigné
par le paramètre interne "parametre_importation" () ["parametre_exportation" ()].

.Notes
* Les fichiers importés et exportés sont présumés être au format .csv bien que
  le délimiteur soit paramétrable. Le suffixe du nom de fichier n’est pas imposé
  pour autant et doit conséquemment faire partie du nom.
* Les droits d'accès sont présumés gérés par ailleurs.
* Une généralisation pourrait être souhaitable.
////
*/

create or replace function "parametre_importation" () returns Text
  immutable leakproof parallel safe
return
  'CoSQL_Importation' ;

create or replace procedure "Importer_par"
  (z_nom_table Text, z_fichier Text, z_delimiteur char default ',')
language sql as
$$
  call
    "Importer" (
      z_nom_table,
      "Parametre_interne_valeur"("parametre_importation" ()),
      z_fichier,
      z_delimiteur
      );
$$;
comment on procedure "Importer_par" is $$
////
."Importer_par" (z_requete Text, z_fichier Text, z_delimiteur char default ',');

* Même fonctionnalité que "Importer" si ce n'est que le répertoire est celui
  déterminé globalement par le paramètre interne "parametre_importation" ().
////
$$;

create or replace function "parametre_exportation" () returns Text
  immutable leakproof parallel safe
return
  'CoSQL_Exportation' ;

create or replace procedure "Exporter_par"
  (z_requete Text, z_fichier Text, z_delimiteur char default ',')
language sql as
$$
  call
    "Exporter" (
      z_requete,
      "Parametre_interne_valeur"("parametre_exportation" ()),
      z_fichier,
      z_delimiteur
    );
$$;
comment on procedure "Exporter_par" is $$
////
."Exporter_par" (z_requete Text, z_fichier Text, z_delimiteur char default ',');

* Même fonctionnalité que "Exporter" si ce n'est que le répertoire est celui
  déterminé globalement par le paramètre interne "parametre_exportation" ().
////
$$;

/*
============================================================================== Z
CoSQL_IMEX_pub-par.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoSQL_def.sql
============================================================================== Z
*/
