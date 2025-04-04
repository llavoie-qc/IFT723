/*
////
============================================================================== A
CoSQL_Tempus_Epoch_ex.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_Tempus
Résumé : Expérimentation avec la représentation « epoch » de SQL.
Projet : CoSQL_2024-2
Responsable : Luc.Lavoie@USherbrooke.ca
Version : 001 (2024-07-29)
Statut : en cours de développement
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 14 à 16 (incl.)
============================================================================== A
*/

set schema 'CoSQL';
set time zone 'UTC' ;

select
  extract(epoch from Timestamp with time zone   '4713-01-01 00:00:00.000000+00 BC') as min,
  extract(epoch from Timestamp with time zone   '4713-01-02 00:00:00.000000+00 BC') as min_succ,
  extract(epoch from Timestamp with time zone   '1969-12-31 00:00:00.000000+00 AD') as zero_pred,
  extract(epoch from Timestamp with time zone   '1970-01-01 00:00:00.000000+00 AD') as zero,
  extract(epoch from Timestamp with time zone   '1970-01-02 00:00:00.000000+00 AD') as zero_succ,
  extract(epoch from Timestamp with time zone '294276-12-30 00:00:00.000000+00 AD') as max_pred,
  extract(epoch from Timestamp with time zone '294276-12-31 00:00:00.000000+00 AD') as max;

select
  extract(epoch from Timestamp with time zone   '4713-01-01 00:00:00.000000+00 BC') as min,
  extract(epoch from Timestamp with time zone   '4713-01-01 00:00:00.000001+00 BC') as min_succ,
  extract(epoch from Timestamp with time zone   '1969-12-31 23:59:59.999999+00 AD') as zero_pred,
  extract(epoch from Timestamp with time zone   '1970-01-01 00:00:00.000000+00 AD') as zero,
  extract(epoch from Timestamp with time zone   '1970-01-01 00:00:00.000001+00 AD') as zero_succ,
  extract(epoch from Timestamp with time zone '294276-12-31 23:59:59.999998+00 AD') as max_pred,
  extract(epoch from Timestamp with time zone '294276-12-31 23:59:59.999999+00 AD') as max;

select
  extract(epoch from Timestamp with time zone   '9999-12-31 23:59:59.999998+00 AD') as x1,
  extract(epoch from Timestamp with time zone   '9999-12-31 23:59:59.999999+00 AD') as x2,
  extract(epoch from Timestamp with time zone  '10000-01-01 00:00:00.000000+00 AD') as x3,
  extract(epoch from Timestamp with time zone  '19999-12-31 23:59:59.999998+00 AD') as x4,
  extract(epoch from Timestamp with time zone  '19999-12-31 23:59:59.999999+00 AD') as x5,
  extract(epoch from Timestamp with time zone  '20000-01-01 00:00:00.000000+00 AD') as x6,
  extract(epoch from Timestamp with time zone '199999-12-31 23:59:59.999998+00 AD') as x7,
  extract(epoch from Timestamp with time zone '199999-12-31 23:59:59.999999+00 AD') as x8,
  extract(epoch from Timestamp with time zone '200000-01-01 00:00:00.000000+00 AD') as x9;

/*
////

* Le type de base doit être le TAI (donc discret et non coordonné) représenté par un "Entier".
* Les granularités utiles me semblent être :
  - Nano : 10^-9^ seconde -> NanoPoint
  - Micro : 10^-6^ seconde -> MicroPoint
  - Milli : 10^-3^ seconde -> MilliPoint
  - Seconde : 1 seconde -> SPoint
  - Minute : 60 secondes -> MPoint
  - Heure : 60 x 60 secondes -> HPoint
  - Kilo : 10^3^ secondes -> KiloPoint
  - Jour : 24 x 60 x 60 secondes -> JPoint
  - Mega : 10^6^ secondes -> MegaPoint
  - Giga : 10^9^ secondes -> GigaPoint
  - Année : a x 24 x 60 x 60 secondes -> APoint (Que vaut a? Consulter le BIPM)
* Pour chacun de ces types, il faut déterminer les limites en fonction de la représentation
* Pour les conversions temporelles, il faut prévoir xPoint <-> yPoiint, pour tout x et tout y.
* Dans un premier temps je propose de mettre en oeuvre MicroPoint, ensuite SPoint et JPoint
* Pour les conversions calendaires, il faut prévoir
  - MicroPoint <-> Timestamp UTC (sans fuseau horaire)
  - SPoint <-> Timestamp UTC (sans fuseau horaire)
  - JPoint <-> Date (néo-grégorien normalisé)
* Pour les conversions calendaires, voir le BIP pour les dates charnières
* Pour chacune de ces conversions, il faut déterminer les limites locales
  - TimeStamp à la microseconde près, à la seconde près et au jour près
  - Date, au jour près

////
*/

create or replace function echantillon_T () returns
  table (v Text)
begin atomic
  select * from (
  values
    (  '4713-01-01 00:00:00.000000+00 BC'),
    (  '4713-01-01 00:00:00.000001+00 BC'),
    (  '2999-12-31 23:59:59.999999+00 BC'),
    (  '3000-01-01 00:00:00.000000+00 BC'),
    (  '3000-01-01 00:00:00.000001+00 BC'),
    (  '3000-01-01 00:00:00.000001+00 BC'),
    (  '3000-01-01 00:00:00.000010+00 BC'),
    (  '3000-01-01 00:00:00.000100+00 BC'),
    (  '3000-01-01 00:00:00.001000+00 BC'),
    (  '3000-01-01 00:00:00.010000+00 BC'),
    (  '3000-01-01 00:00:00.100000+00 BC'),
    (  '3000-01-01 00:00:00.999999+00 BC'),
    (  '3000-01-01 00:00:00.999998+00 BC'),
    (  '0002-12-31 23:59:59.999999+00 BC'),
    (  '0001-01-01 00:00:00.000000+00 BC'),
    (  '0001-01-01 00:00:00.000001+00 BC'),
    (  '0001-12-31 23:59:59.999999+00 BC'),
    (  '0001-01-01 00:00:00.000000+00 AD'),
    (  '0001-01-01 00:00:00.000001+00 AD'),
    (  '1969-12-31 23:59:59.999999+00 AD'),
    (  '1970-01-01 00:00:00.000000+00 AD'),
    (  '1970-01-01 00:00:00.000001+00 AD'),
    (  '2023-12-31 23:59:59.999999+00 AD'),
    (  '2024-01-01 00:00:00.000000+00 AD'),
    (  '2024-01-01 00:00:00.000001+00 AD'),
    (  '2024-01-01 00:00:00.000010+00 AD'),
    (  '2024-01-01 00:00:00.000100+00 AD'),
    (  '2024-01-01 00:00:00.001000+00 AD'),
    (  '2024-01-01 00:00:00.010000+00 AD'),
    (  '2024-01-01 00:00:00.100000+00 AD'),
    (  '2024-01-01 00:00:00.999998+00 AD'),
    (  '2024-01-01 00:00:00.999999+00 AD'),
    (  '2999-12-31 23:59:59.999999+00 AD'),
    (  '3000-01-01 00:00:00.000000+00 AD'),
    (  '3000-01-01 00:00:00.000001+00 AD'),
    (  '3000-01-01 00:00:00.000010+00 AD'),
    (  '3000-01-01 00:00:00.000100+00 AD'),
    (  '3000-01-01 00:00:00.001000+00 AD'),
    (  '3000-01-01 00:00:00.010000+00 AD'),
    (  '3000-01-01 00:00:00.100000+00 AD'),
    (  '3000-01-01 00:00:00.999998+00 AD'),
    (  '3000-01-01 00:00:00.999999+00 AD'),
    (  '9999-12-31 23:59:59.999998+00 AD'),
    (  '9999-12-31 23:59:59.999999+00 AD'),
    ( '10000-01-01 00:00:00.000000+00 AD'),
    ( '10000-01-01 00:00:00.000010+00 AD'),
    ( '10000-01-01 00:00:00.000100+00 AD'),
    ( '10000-01-01 00:00:00.001000+00 AD'),
    ( '10000-01-01 00:00:00.010000+00 AD'),
    ( '10000-01-01 00:00:00.100000+00 AD'),
    ('294247-01-01 00:00:00.000000+00 AD'),
    ('294247-01-10 04:00:54.775808+00 AD')
    /* ,
    ('294276-12-31 23:59:58.000000+00 AD'), -- e=9224318015999.999
    ('294276-12-31 23:59:59.000000+00 AD'), -- e=9224318015999.999
    ('294276-12-31 23:59:59.999049+00 AD')  -- e=9224318015999.999
    ('294276-12-31 23:59:59.999050+00 AD'), -- [22008] ERROR: timestamp out of range: "9.22432e+12"
    ('294276-12-31 23:59:59.999998+00 AD'),
    ('294276-12-31 23:59:59.999999+00 AD')
    */
  ) as V(v);
end;

select
  v,
  t1,
  e,
  t2,
  t1 = t2 as ok
from echantillon_T() as X(v),
  lateral cast (v as Timestamp with time zone) as t1,
  lateral extract(epoch from t1) as e,
  lateral to_timestamp(e) as t2 ;

select
  v,
  t1,
  e,
  t2,
  t1 = t2 as ok
from echantillon_T() as X(v),
  lateral cast (v as "Estampille") as t1,
  lateral extract(epoch from t1) as e,
  lateral to_timestamp(e) as t2 ;


with R as
  (
  select
    extract(epoch from "estampille_min"()) as min,
    extract(epoch from "estampille_max"()) as max
  )
select R.min, to_timestamp(R.min), 0, to_timestamp(0), R.max, to_timestamp(R.max)
from R;

with R as
  (
  select
    extract(epoch from "estampille_min"()) as min,
    extract(epoch from "estampille_max"()) as max
  )
select R.min, to_timestamp(R.min), 0, to_timestamp(0), R.max, to_timestamp(R.max)
from R;

create or replace function "entier_min" () returns "Entier"
  immutable leakproof parallel safe
return
  -9223372036854775808;
comment on function "entier_min" is $$
Plus petite valeur entière
$$;

--
--  TAI
--

create domain "TAI" as Bigint ;

create or replace function "conv_Estampille_a_TAI"(e "Estampille") returns "TAI"
  immutable leakproof parallel safe
return
  cast (trunc(extract(epoch from e) * 1000000) as "TAI");
comment on function "conv_Estampille_a_TAI" is $$
...
$$;

create or replace function "conv_TAI_a_Estampille"(t "TAI") returns "Estampille"
  immutable leakproof parallel safe
return
  to_timestamp(cast (t as double precision) / 1000000.0) ;
comment on function "conv_Estampille_a_TAI" is $$
...
$$;

-- Seul Les TAI reculent (beaucoup) plus loin dans le passé; les estampilles vont (un peu) plus loin dans le futur
select -- -210863520000000000
  "conv_Estampille_a_TAI"("estampille_min"()) ;
select -- out of range
  "conv_Estampille_a_TAI"("estampille_max"()) ;
select -- TAI_Max 294247-01-10 04:00:54.775808 +00:00
  to_timestamp("entier_max"()/1000000::float8) ;
select -- 9223372036854775800
  "conv_Estampille_a_TAI"(to_timestamp("entier_max"()/1000000::float8)) ;


/*
Comment déterminer la contrainte de granularité applicable à l'opérande
de la fonction to_timestamp (écho->timestamp) afin d'obtenir une
fonction inversible en tout point.
Cette contrainte peut-elle être formulé en terme de période ?
symétique (relativement à un origine parmi {0001-01-01, 1970-01-01}
Par exemple, la granularité 10^-6^ s est déjà trop fine pour
0001-01-01 et 3000-01-01
*/

--
-- MicroPoint :
--  asymétrie : 1727-01-01 00:00:00.999999 +00:00 , 2243-01-01 00:00:00.999999 +00:00
--  bornes suggérées : 1718-01-01 00:00:00.000000 .. 2242-12-31 23:59:59.999999
--

with x as (
  select
    -- v,
    e1,
    t,
    e2,
    e1=e2 as ok
  from generate_series (
      timestamp with time zone '2240-01-01 00:00:00.999999+00',
      timestamp with time zone '2400-01-01 00:00:00.999999+00',
      '1 year') as S(e1),
    -- lateral cast (v as "Estampille") as e1,
    lateral "conv_Estampille_a_TAI"(e1) as t,
    lateral "conv_TAI_a_Estampille"(t) as e2
  )
select min (e1)
from x
where not ok ;

with x as (
  select
    -- v,
    e1,
    t,
    e2,
    e1=e2 as ok
  from generate_series (
      timestamp with time zone '1970-01-01 00:00:00.999999+00',
      timestamp with time zone '2400-01-01 00:00:00.999999+00 BC',
      '-1 year') as S(e1),
    -- lateral cast (v as "Estampille") as e1,
    lateral "conv_Estampille_a_TAI"(e1) as t,
    lateral "conv_TAI_a_Estampille"(t) as e2
  )
select max (e1)
from x
where not ok ;

--  seuils approximatifs d’asymétrie : ? , 2243-01-01 00:00:00.999999 +00:00
--  bornes suggérées :

create or replace function "MicroPoint_min"() returns "TAI" -- Oups le décalage entre midi et minuit non pris en compte !!!
  immutable leakproof parallel safe
return
  -- le cast est essentiel afin d'empêcher le décalage horaire intervenant lors
  -- d'une conversion implicite de timestamp vers timestamp with time zone
  cast (extract (epoch from timestamp with time zone '1718-01-01 00:00:00.000000+00 AD')*1000000 as "TAI") ;
comment on function "MicroPoint_min" () is $$
MicroPoint minimal.
$$;

create or replace function "MicroPoint_max"() returns "TAI" -- Oups le décalage entre midi et minuit non pris en compte !!!
  immutable leakproof parallel safe
return
  -- le cast est essentiel afin d'empêcher le décalage horaire intervenant lors
  -- d'une conversion implicite de timestamp vers timestamp with time zone
  cast (extract (epoch from timestamp with time zone '2242-12-31 23:59:59.999999+00 AD')*1000000 as "TAI") ;
comment on function "MicroPoint_max" () is $$
MicroPoint maximal.
$$;

select
  "MicroPoint_min"(), "conv_TAI_a_Estampille"("MicroPoint_min"()),
  "MicroPoint_max"(), "conv_TAI_a_Estampille"("MicroPoint_max"());

create domain "MicroPoint" as
  "TAI"
  constraint "MicroPoint_intervalle" check (value between "MicroPoint_min"() and "MicroPoint_min"()) ;

with x as (
  select
    e1,
    t,
    e2,
    e1=e2 as ok2
  from generate_series (
      "conv_TAI_a_Estampille"("MicroPoint_max"()) - '1 second'::interval,
      "conv_TAI_a_Estampille"("MicroPoint_max"()),
      '1 microsecond') as S(e1),
    -- lateral cast (v as "Estampille") as e1,
    lateral "conv_Estampille_a_TAI"(e1) as t,
    lateral "conv_TAI_a_Estampille"(t) as e2
  )
select e1, t, e2
from x
where not ok2 ;

--
-- MilliPoint :
--  asymétrie : aucune inférieure , 280708-01-01 00:00:00.001 +00:00
--  Sans un premier temps, malqué que 10 bits (log2(1000)) aitent été recupérés,
--  mais l'amplitude de l'invervalle doublait à peine. Pourquoi ?
--  Les erreurs d'arrondi des float8 sous-jacents n'expliquent pas tout.
--  Après quelques essais, on a constaté qu'une deuxième troncature était requise
--  afin de retirer les «saletés» produites aux dernières positions franctionnaires
--  par to_timestamp.
--  bornes suggérées : 4713-01-01 00:00:00.000 BC .. 280707-01-01 23:59:59.999 AD
--

create or replace function "conv_Estampille_a_TAI_milli"(e "Estampille") returns "TAI"
  immutable leakproof parallel safe
return
  cast (trunc(extract(epoch from e) * 1000.0) as "TAI");
comment on function "conv_Estampille_a_TAI_milli" is $$
...
$$;

create or replace function "conv_TAI_milli_a_Estampille"(t "TAI") returns "Estampille"
  immutable leakproof parallel safe
  -- la deuxième troncature (le cast sut timestamp(3) ne devrait pas être requise...
return
  cast(to_timestamp(cast (t as double precision) / 1000.0) as timestamp(3) with time zone) ;
comment on function "conv_TAI_milli_a_Estampille" is $$
...
$$;

create or replace function "conv_TAI_milli_a_Estampille"(t "TAI") returns "Estampille"
  immutable leakproof parallel safe
  -- ...
return
  to_timestamp(cast(trunc(cast (t as numeric) / 1000.0, 3) as double precision))  ;
comment on function "conv_TAI_milli_a_Estampille" is $$
...
$$;


create or replace function "conv_TAI_milli_a_Estampille_v2"(t "TAI") returns "Estampille"
  immutable leakproof parallel safe -- pas mieux, inutile !
return
  to_timestamp(cast (t / 1000 as double precision) + (cast (abs(t) % 1000 as double precision))/1000.0) ;
comment on function "conv_TAI_milli_a_Estampille_v2" is $$
...
$$;

with x as (
  select
    e1,
    t,
    e2,
    e1=e2 as ok2,
    e4,
    e1=e4 as ok4
  from generate_series (
      timestamp with time zone '280000-01-01 00:00:00.001+00',
      timestamp with time zone '281000-01-01 00:00:00.001+00',
      '1 year') as S(e1),
    lateral "conv_Estampille_a_TAI_milli"(e1) as t,
    lateral "conv_TAI_milli_a_Estampille"(t) as e2,
    lateral to_timestamp(extract(epoch from e1)) as e4
  )
select min (e1)
from x
where not ok2 ;

with x as (
  select
    e1,
    t,
    e2,
    e1=e2 as ok2,
    e4,
    e1=e4 as ok4
  from generate_series (
      timestamp with time zone '4700-01-01 00:00:00.999+00 BC',
      timestamp with time zone '4713-12-31 23:59:59.999+00 BC', -- 4713-12-31 23:59:59.999+00
      '-1 year') as S(e1),
    -- lateral cast (v as "Estampille") as e1,
    lateral "conv_Estampille_a_TAI_milli"(e1) as t,
    lateral "conv_TAI_milli_a_Estampille"(t) as e2,
    lateral to_timestamp(extract(epoch from e1)) as e4
  )
select max (e1)
from x
where not ok2 ;

--  seuils approximatifs d’asymétrie : 1727-01-01 00:00:00.999999 +00:00 , 2243-01-01 00:00:00.999999 +00:00
--  bornes suggérées : 1718-01-01 00:00:00.000000 .. 2242-12-31 23:59:59.999

create or replace function "MilliPoint_min"() returns "TAI" -- Oups le décalage entre midi et minuit non pris en compte !!!
  immutable leakproof parallel safe
return
  -- le cast est essentiel afin d'empêcher le décalage horaire intervenant lors
  -- d'une conversion implicite de timestamp vers timestamp with time zone
  cast (extract (epoch from timestamp with time zone '4713-01-01 00:00:00.000 BC')*1000 as "TAI") ;
comment on function "MilliPoint_min" () is $$
MilliPoint minimal.
$$;

create or replace function "MilliPoint_max"() returns "TAI" -- Oups le décalage entre midi et minuit non pris en compte !!!
  immutable leakproof parallel safe
return
  -- le cast est essentiel afin d'empêcher le décalage horaire intervenant lors
  -- d'une conversion implicite de timestamp vers timestamp with time zone
  cast (extract (epoch from timestamp with time zone '280707-01-01 23:59:59.999 AD')*1000 as "TAI") ;
comment on function "MilliPoint_max" () is $$
MilliPoint maximal.
$$;

select
  "entier_min"(),
  "MilliPoint_min"(), "conv_TAI_a_Estampille"("MilliPoint_min"()),
  "MilliPoint_max"(), "conv_TAI_a_Estampille"("MilliPoint_max"()),
  "entier_max"();

/*
-9223372036854775808
- 210863520000000000
 8796090153599999000
 9223372036854775807
*/

with x as (
  select
    e1,
    t,
    e2,
    e1=e2 as ok2
  from generate_series (
      "conv_TAI_milli_a_Estampille"("MilliPoint_max"()) - '1 second'::interval,
      "conv_TAI_milli_a_Estampille"("MilliPoint_max"()),
      '1 millisecond') as S(e1),
    -- lateral cast (v as "Estampille") as e1,
    lateral "conv_Estampille_a_TAI_milli"(e1) as t,
    lateral "conv_TAI_milli_a_Estampille"(t) as e2
  )
select e1, t, e2
from x
where not ok2 ;


create domain "MilliPoint" as
  "TAI"
  constraint "MilliPoint_intervalle" check (value between "MilliPoint_min"() and "MilliPoint_min"()) ;
