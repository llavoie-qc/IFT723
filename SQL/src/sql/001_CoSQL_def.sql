/*
////
============================================================================== A
CoSQL_def.sql
------------------------------------------------------------------------------ A
Produit : CoSQL
Résumé : Schéma contenant l’environnement SQL commun du CoLOED.
Projet : CoSQL_2024-2
Responsable : Luc.Lavoie@USherbrooke.ca
Version : 103 (2024-08-12)
Statut : en cours de développement
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 14 à 16 (incl.)
============================================================================== A
*/

drop schema if exists "CoSQL" cascade ;
create schema "CoSQL";
comment on schema "CoSQL" is $$
////
CoSQL est l’environnement SQL commun du CoLOED.

Les parties publiques et privées n’ont pas été distinguées, puisqu’_a priori_
tous les composants de la BD l’incorporant peuvent faire appel à ses entités,
mais seules les personnes responsables de la BD devraient être en mesure de
les mettre à niveau.

Les sous-composants disponibles sont :

* "Base" [sans état, sans introspection] :
  - Types génériques : Text, "Entier", "Cardinal", "Ordinal", "Estampille".
  - Opérateurs logiques : "bool_imp", "bool_eqv".

* "Base", extension « rel » [sans état, *avec* introspection] :
  - Opérateur d’égalité relationnelle : "rel_ega".

* "Verif" [sans état, sans introspection ; dep("Base")] :
  - Routines de gestion des assertions :
    "Asserter", "Asserter_exception", "Manifester", "Manisfester_exception".

* "IMEX" [sans état, sans introspection ; dep("Base")] :
  - Routines d’import-export de fichiers au droit du serveur.
  - Pour le moment limité aux formats CSV
    (le délimiteur de champ pouvant cependant être paramétré).

* "Param" [*avec* état, sans introspection, stable ; dep("Base")] :
  - Gestion de paramètres internes propres à la BD.

* "IMEX", extension « par » [sans état propre, sans introspection, stable ; dep("IMEX", "Param", "Base")] :
  - Extension de "IMEX" relativement à un dépôt (répertoire) associé à la BD par l’entremise de "Param".
  - Typiquement, ce dépôt est localisé sur le serveur hébergeant le SGBD et
    le compte propriétaire du service associé au SGBD doit y avoir accès.

CoSQL est le fruit de la fusion et de la refonte de GRIIS_Base et Metis_Base.

.Notes de mise en oeuvre
Le code ne doit pas être soumis à un formateur, car la mise en forme opérée
par ce dernier introduit généralement des erreurs, notamment :

 * guillemets fautifs autour du mot réservé `value` ;
 * guillemets fautifs autour de l’opérateur `||`.

De plus, les formateurs « cochonnnent » généralement la présentation,
notamment :

 * ils analysent incorrectement les corps de routines SQL (begin atomic ... end) ;
 * la gestion des fins de ligne et des indentations n’est pas uniforme.

Bien que la version 12 de PostgreSQL soit encore soutenue (au 2024-07-31), il
a été décidé de ne démarrer le soutien de CoLOED qu’à partir de la version 14
pour les raisons suivantes :

* le traitement des déclarations de routines conformes au standard ISO 9075:2016
  a été offert dès la version 11.4, de multiples erreurs (tant du compilateur,
  que du connecteur JDBC que d’autres outils connexes) sont demeurées
  présentes jusqu’à la version 14.
* le soutien de la version 12 cessant le 2024-11-14, celui de la version 13, le
  2025-11-13 (voir https://www.postgresql.org/support/versioning/), il n’est
  pas apparu justifié de consacrer des efforts au développement et à la
  mise en place des contournements nécessaires puisque nous ne prévoyons
  diffuser publiquement CoLOED qu’à partir de la mi-novembre 2024.
////
$$;

/*
============================================================================== Z
CoSQL_def.sql
------------------------------------------------------------------------------ Z
////
.Contributeurs
  (CK01) Christina.Khnaisser@USherbrooke.ca
  (LL01) Luc.Lavoie@USherbrooke.ca
  (MD01) Marc.Dupuis@USherbrooke.ca
  (SD01) Samuel.Dussault@USherbrooke.ca

.Adresses, droits d’auteur et copyright
  2016-2019
  Groupe Μητις (Metis)
  Faculté des sciences
  Université de Sherbrooke (Québec) J1K 2R1
  CANADA
  http://info.usherbrooke.ca/llavoie/

  2020-2023
  GRIIS (Groupe de recherche interdisciplinaire en informatique de la santé)
  Faculté de médecine et sciences de la santé et Faculté des sciences
  Université de Sherbrooke (Québec) J1K 2R1
  CANADA
  https://griis.ca/

  2024-...
  CoFELI (Collectif francophone pour l’enseignement libre de l’informatique)
  https://github.com/CoFELI

.Licences
  Code sous licence LILIQ-R+ (https://forge.gouv.qc.ca/licence/liliq-v1-1/).
  Documentation sous licence CC-BY-4.0, (https://creativecommons.org/licenses/by/4.0/).

.Tâches projetées
  2022-10-03 (LL01) : Faciliter la variation de la politique Asserter/Manifester (PAM).
    * Ajout d’une série de routines ayant un paramètre supplémentaire déterminant
      la PAM désirée.
    * Ajout d’une série de routines se conformant à une PAM établie globalement.

.Tâches réalisées
  2024-08-12 (LL01) : Documentation de la version 103.
  2024-07-24 (LL01) : Harmonisation pour Μητις, GRIIS et CoFELI.
  2022-09-28 (LL01) : Routines de vérification de l’occurrence d’exceptions.
    * Ajouts :
        _assert_exception, Assert_Exception,
        _manifest_exception, Manifest_Exception.
    * Refactorisations mineures.
    * Commentaires.
  2022-07-25 (LL01) : Recentrage du module
    * Retrait de Taux et Pourcentage.
    * Déplacement et renommage des entités relatives aux courriels dans IETF5222.
  2022-06-24 (LL01) : Déplacement de la gestion des codes vers le module Code.
  2022-06-19 (LL01) : Intégration des propositions Μητις et GRIIS.
  2020-03-21 (LL01) : Création initiale pour le projet ProtoGEM.
  2016-01-03 (LL01) : Création initiale pour le groupe Μητις.

.Références
  [std] https://github.com/CoLOED/Scriptorum/blob/main/pub/STD-SQL-01_NT.pdf
////
============================================================================== Z
*/
