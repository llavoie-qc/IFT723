/*
////
============================================================================== A
CoSQL_Base_ex.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_Base
Résumé : Expérimentations en vue du développement de CoSQL_Base.
Projet : CoSQL_2024-2
Responsable : Luc.Lavoie@USherbrooke.ca
Version : 103 (2024-08-12)
Statut : en cours de développement
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 14 à 16 (incl.)
============================================================================== A
*/

set schema 'CoSQL';

-- En faisant varier le fuseau horaire implicite, on fait varier les conversions
-- automatiques implicites soit au niveau du serveur (via la commande set time zone)
-- soit par l’entremise du client en fonction des paramètres de connexion.
-- Pour le moment, les comportements sont difficilement prévisibles à moins
-- d’imposer le fuseau UTC partout.

-- La situation est particulièrement étrange en regard du convertisseur explicite
-- AT TIME ZONE <fuseau> dont le comportement varie non seulement en fonction
-- du paramètre explicite, mais aussi des valeurs implicites!

-- Suggestion, faire les tests pour <fuseau> dans {'-05', 'UTC', '+05'}

set time zone '+05' ;

--
-- Pairé avec le «commit» à la fin, le «start transaction» permet de
-- vérifier la différenciation correcte du temps courant et du temps de transaction.
--

  -- TRAN --  start transaction ;

  /* TSTI */  select "test_identification" ('CoSQL_Base_ex', 'DÉBUT') ;

select
  'Temps de la transaction',
  Current_TimeStamp as cts,
  'Temps courant du processeur au début de la transaction',
  Clock_TimeStamp() as lts ;

-- Ces tests illustrent la variation dans l'affichage

select
  'estampille_min()' as test,
  "estampille_min"() as min_tz,                                                 -- DG OK           ; PG décalé -05:13:32 !!!
  "estampille_min"() at time zone 'UTC' as min_tz_at_utc;                       -- DG moins infini ; PG OK

select
  'Timestamp ''4713-01-01 00:00:00+00 BC''' as test,
   Timestamp  '4713-01-01 00:00:00+00 BC'   as ts,                              -- DG moins infini ; PG OK
   Timestamp  '4713-01-01 00:00:00+00 BC'   at time zone 'UTC' as tz_at_utc,    -- DG OK           ; PG écalé -05:13:32 !!!
   cast (     '4713-01-01 00:00:00+00 BC'   as Timestamp) as ts_cast;           -- DG moins infini ; PG OK

select
  'Timestamp with time zone ''4713-01-01 00:00:00+00 BC''' as test,
   Timestamp with time zone  '4713-01-01 00:00:00+00 BC' as tz,                                   -- DG OK           ; PG décalé -05:13:32 !!!
   Timestamp with time zone  '4713-01-01 00:00:00+00 BC' at time zone 'UTC' as ts_at_utc,         -- DG moins infini ; PG OK
   cast (                    '4713-01-01 00:00:00+00 BC' as Timestamp with time zone) as tz_cast; -- DG OK           ; PG décalé -05:13:32 !!!

  select
  '"Estampille" ''4713-01-01 00:00:00+00 BC''' as test,
   "Estampille"  '4713-01-01 00:00:00+00 BC' as est,                            -- DG OK           ; PG décalé -05:13:32 !!!
   "Estampille"  '4713-01-01 00:00:00+00 BC' at time zone 'UTC' as ts_at_utc,   -- DG moins infini ; PG OK
   cast (        '4713-01-01 00:00:00+00 BC' as "Estampille") as est_cast;      -- DG OK           ; PG décalé -05:13:32 !!!

/*
select
  "estampille_chronon"(),
  "estampille_ncs"() ;
select
  '4713-01-01 00:00:00.000000+00 BC'::"Estampille",
  '4713-01-01 00:00:00.000000+00 BC'::"Estampille" at time zone '0000',
  "estampille_min"(),
  "estampille_min"() at time zone '0000',
  "estampille_min"()::"Estampille",
  "estampille_min"()::"Estampille" at time zone '0000' ;
select
  '294276-12-31 23:59:59.999999+00 AD'::"Estampille",
  '294276-12-31 23:59:59.999999+00 AD'::"Estampille" at time zone '0000',
  "estampille_max"(),
  "estampille_max"() at time zone '0000',
  "estampille_max"()::"Estampille",
  "estampille_max"()::"Estampille" at time zone '0000' ;
*/

--
-- En conclusion
--  1. NE PAS utiliser TimeStamp (without time zone)
--  2. NE PAS utiliser at time zone (peu importe lequel)
--

select
  'Temps de la transaction',
  Current_TimeStamp as cts,
  'Temps courant du processeur en fin de transaction',
  Clock_TimeStamp() as lts;

  -- TRAN --  commit ;

  select
  'Temps de la transaction SUIVANTE',
  Current_TimeStamp as cts,
  'Temps courant du processeur en fin de transaction',
  Clock_TimeStamp() as lts;

  /* TSTI */  select "test_identification" ('CoSQL_Base_ex', 'FIN') ;

/*
============================================================================== Z
CoSQL_Base_ex.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoSQL_def.sql
============================================================================== Z
*/
