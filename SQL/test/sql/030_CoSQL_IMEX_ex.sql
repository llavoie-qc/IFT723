/*
////
============================================================================== A
CoSQL_IMEX_ex.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_IMEX
Résumé : Expérimentations en vue du développement de CoSQL_IMEX.
Projet : CoSQL_2024-2
Responsable : Luc.Lavoie@USherbrooke.ca
Version : 103 (2024-08-12)
Statut : en cours de développement
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 14 à 16 (incl.)
============================================================================== A
*/

set schema 'CoSQL';

drop table if exists IMEX_resultat ;
create table IMEX_resultat (ok Boolean) ;
insert into IMEX_resultat values (true) ;

create or replace function "Extraire_ok"
  (z_nom_schema text, z_nom_table text, z_attribut text)
  returns Boolean
language sql as
$$
  select ok from IMEX_resultat ;
$$;

select "Extraire_ok" ('"CoSQL"', 'IMEX_resultat', 'ok') ;

select
      format(
      'SELECT %3$s FROM %1$s.%2$s',
      '"CoSQL"',
      'IMEX_resultat',
      'ok'
      );

create or replace function "Extraire_ok"
  (z_nom_schema text, z_nom_table text, z_attribut text)
  returns Boolean
  volatile
  language plpgsql as
$$
declare
  b Boolean ;
begin
  execute
    format(
      'SELECT %3$s FROM %1$s.%2$s',
      z_nom_schema,
      z_nom_table,
      z_attribut
    )
  into b;
  return b;
end
$$;

select "Extraire_ok" ('"CoSQL"', 'IMEX_resultat', 'ok') ;

select
  format ('
    with
      A as (select count(*) as nb from %1$s),
      B as (select count(*) as nb from %2$s),
      J as (select count(*) as nb from %1$s natural join %2$s)
    select
          (select nb from J) = (select nb from A)
      and (select nb from J) = (select nb from B) as ok
    into ok
  ',
  '"CoSQL".IMEX_import',
  '"CoSQL".IMEX_export'
  );

create or replace function "rel_ega"
  (z_nom_table1 text, z_nom_table2 text)
  -- soit deux tables désignées par z_nom_table1 et z_nom_table2
  -- de même liste d'attributs (même identifiants et mêmes types),
  -- la fonction détermine si ces deux tables sont égales au sens relationnel
  -- du terme (à savoir une relation est un ensemble, pas une collection).
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
        and (select nb from J) = (select nb from B) as ok',
      z_nom_table1,
      z_nom_table2
    )
  into b;
  return b;
end
$$;

select "rel_ega" ('"CoSQL".IMEX_import', '"CoSQL".IMEX_export') ;

select "rel_ega" ('IMEX_import', 'IMEX_export') ;

/*
call "Asserter" ('#1 : "export-import réussi',
  (
  with
    E as (select count(*) as nb from IMEX_export),
    I as (select count(*) as nb from IMEX_import),
    J as (select count(*) as nb from IMEX_import natural join IMEX_export)
  select
        (select nb from J) = (select nb from E)
    and (select nb from J) = (select nb from I) as ok
  ) ) ; -- [0A000] ERROR: cannot use subquery in CALL argument

Puisqu'il s'agit d'une limitation propre à PostgreSQL, le mécanisme
  do $$ declare ... begin ... end $$
propre à PostgreSQL sera utilisée pour la contourner.
*/

do
$$
  declare
    ok Boolean ;
  begin
    with
      E as (select count(*) as nb from IMEX_export),
      I as (select count(*) as nb from IMEX_import),
      J as (select count(*) as nb from IMEX_import natural join IMEX_export)
    select
          (select nb from J) = (select nb from E)
      and (select nb from J) = (select nb from I) as ok
    into ok ;
  call "Asserter" ('#1 : "export-import réussi', ok) ;
  end
$$;

select "rel_ega" ('IMEX_import', 'IMEX_export') ;

do
$$
  declare
    ok Boolean ;
  begin
    select "rel_ega" ('IMEX_import', 'IMEX_export') into ok ;
    call "Asserter" ('#1 : "export-import réussi', ok) ;
  end
$$;


drop table if exists IMEX_resultat ;

select
    format(
      'COPY (%1$s) TO %2$L with (header, format csv, delimiter ''%3$s'')',
      'select * from IMEX_export',
      '/Users/Shared/DGS/CoLOED/SQL/temp/test/' || 'IMEX.csv',
      ','
    );

  execute
    format(
      'COPY (%1$s) TO %2$L with (header, format csv, delimiter ''%3$s'')',
      'select * from IMEX_export',
      '/Users/Shared/DGS/CoLOED/SQL/temp/test/' || 'IMEX.csv',
      ','
    );


/*
============================================================================== Z
CoSQL_IMEX_ex.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoSQL_def.sql
============================================================================== Z
*/
