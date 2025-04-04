/*
////
============================================================================== A
CoSQL_Param_pri.sql
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
-- Entités privées du composant
-- Ici, la table devant contenir les paramètres.
--

create table Parametre_interne (
  parametre Text not null,
  valeur Text not null,
  annotation Text not null,
  constraint Parametre_interne_cc0 primary key (parametre)
  );
comment on table Parametre_interne is $$
Stockage des paramètres définis ;
* parametre   -- l’identifiant unique associé au paramètre (sensible à la casse) ;
* valeur      -- la valeur dudit paramètre ;
* annotation  -- une description du paramètre et de son utilisation (peut contenir des fins de ligne).
$$

/*
============================================================================== Z
CoSQL_Param_pri.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoSQL_def.sql
============================================================================== Z
*/
