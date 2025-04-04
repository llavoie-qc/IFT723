/*
////
============================================================================== A
CoSQL_Base_pub.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_Base
Résumé : Sous-composant comprenant la base de l’environnement SQL commun du CoLOED.
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
=== Types textuels

Plusieurs dialectes SQL propose un type textuel non borné a priori.
Celui-ci est le plus souvent dénoté « Text » (TEXT, Text ou text).
Ce type est présumé pour être manipulable par tous les opérateurs utilisant
un opérande textuel (CHAR ou VARCHAR) prévus par la norme ISO 9075:2016.

Si le dialecte utilisé ne définit pas un tel type, "CoSQL" le fait de la façon
la moins fautive possible.
Dans ce contexte, l’identifiant ne doit donc pas être délimité.
////
*/

  -- XXXX --  create domain Text as VARCHAR(?) ;
  -- XXXX --  comment on domain Text is 'Type textuel non borné a priori.' ;


/*
////
=== Types entiers

Définition des types entiers les plus étendus associés aux opérandes des
opérateurs pris en compte par la norme ISO 9075:2016 : "Entier", "Cardinal",
"Ordinal".
Afin de faciliter le diagnostic, la coercition « not null » leur est appliquée
afin de provoquer la levée d’une exception le plus précocement possible en cas
d'indétermination.

Pour chacun de ces trois types e parmi {entier, cardinal, ordinal}, les fonctions
"e_min"() et "e_max"() retournent respectivement la valeur minimale et la valeur
maximale de e.
////
*/

create domain "Entier" as
  Bigint not null ;
comment on domain "Entier" is $$
Sous-ensemble fini des entiers naturels
(le plus grand ensemble possible en regard de la plateforme).
$$;

create or replace function "entier_min" () returns "Entier"
  immutable leakproof parallel safe
return
  -9223372036854775808;
comment on function "entier_min" is $$
Plus petite valeur entière
$$;

create or replace function "entier_max" () returns "Entier"
  immutable leakproof parallel safe
return
  9223372036854775807;
comment on function "entier_max" is $$
Plus grande valeur entière
$$;


create domain "Cardinal" as
  Bigint not null
  check (value >= 0) ;
comment on domain "Cardinal" is $$
Sous-ensemble fini des entiers non négatifs
(le plus grand ensemble possible en regard de la plateforme).
$$;

create or replace function "cardinal_min" () returns "Cardinal"
  immutable leakproof parallel safe
return
  0;
comment on function "cardinal_min" is $$
Plus petite valeur cardinale
$$;

create or replace function "cardinal_max" () returns "Cardinal"
  immutable leakproof parallel safe
return
  9223372036854775807;
comment on function "cardinal_max" is $$
Plus grande valeur cardinale
$$;


create domain "Ordinal" as
  Bigint not null
  check (value >= 1) ;
comment on domain "Ordinal" is $$
Sous-ensemble fini des entiers positifs
(le plus grand ensemble possible en regard de la plateforme).
$$;

create or replace function "ordinal_min" () returns "Ordinal"
  immutable leakproof parallel safe
return
  1;
comment on function "ordinal_min" is $$
Plus petite valeur cardinale
$$;

create or replace function "ordinal_max" () returns "Ordinal"
  immutable leakproof parallel safe
return
  9223372036854775807;
comment on function "ordinal_max" is $$
Plus grande valeur cardinale
$$;


/*
////
=== Type Booléen

L’implication et l’équivalence sont des opérateurs logiques usuels,
mais non pris en compte par la norme ISO 9075:2016. Les opérateurs
sont définis par "CoSQL".

  * "bool_imp" (a Boolean, b Boolean)
  * "bool_eqv" (a Boolean, b Boolean)
////
*/

create or replace function "bool_imp" (a Boolean, b Boolean) returns Boolean
  immutable leakproof parallel safe
return
  b or not a;
comment on function "bool_imp" is $$
Implication logique (==>).
ante : (a is not null) and (b is not null)
res  : (a ==> b)
$$;

create or replace function "bool_eqv" (a Boolean, b Boolean) returns Boolean
  immutable leakproof parallel safe
return
  b = a;
comment on function "bool_eqv" is $$
Équivalence logique (<==>).
ante : (a is not null) and (b is not null)
res  : (a <==> b)
$$;

/*
////
=== Types temporels (Estampille)

Le type Timestamp est malheureusement très variablement mis en oeuvre par les dialectes SQL.
De façon à uniformiser les vérifications et les traitements, le type "Estampille" est défini
comme un point temporel (donc discret et fini) compris entre "estampille_min" et "estampille_max".
La granularité est est établie par la durée du chronon ("estampille_chronon", de type « Interval »)
et le nombre de chronons par seconde ("estampille_ncs", de type "Ordinal") sous la
contrainte suivante :

  "estampille_chronon" * "estampille_ncs" = 1 seconde

Par ailleurs, l’échelle de référence du type "Estampille" est le temps universel
coordonné (UTC) au méridien de Greenwich (0000). Toute valeur indexée en fonction
d’un fuseau horaire doit être convertie (elle l’est implicitement
en PostgreSQL en regard du type « Timestamp », du moins depuis la version 12).

Finalement sont définies des fonctions "gen_VT", "gen_TT" et "gen_TC" permettant
d’obtenir :

* le temps de validité (_valid time_, _user time_) ;
* le temps de transaction (_transaction time_, _system time_, _log time_) ;
* le temps courant (_current time_, _real time_).

.Mise en garde
« In a literal that has been determined to be timestamp without time zone,
PostgreSQL will silently ignore any time zone indication.
That is, the resulting value is derived from the date/time fields in the
input value, and is not adjusted for time zone.

For timestamp with time zone, the internally stored value is always in
UTC (Universal Coordinated Time, traditionally known as Greenwich Mean Time, GMT).
An input value that has an explicit time zone specified is converted to UTC using
the appropriate offset for that time zone.
If no time zone is stated in the input string, then it is assumed to be in
the time zone indicated by the system's [.red]#TimeZone# parameter, and is
converted to UTC using the offset for the timezone zone.

When a timestamp with time zone value is output, it is always converted from UTC
to the current timezone zone, and displayed as local time in that zone.
To see the time in another time zone, either change timezone or use the
*AT TIME ZONE* construct (see Section 9.9.4).

Conversions between timestamp without time zone and timestamp with time zone
normally assume that the timestamp without time zone value should be taken
or given as timezone local time.
A different time zone can be specified for the conversion using AT TIME ZONE. »

Attendu que les fonctions du système (CURRENT_TIMESTAMP, CLOCK_TIMESTAMP, LOCAL_TIMESTAMP, etc.)
sont toutes de type TIMESTAMP WITH TIME ZONE, les conversions implicites sont
inéluctables. Il est donc TRÈS difficile de faire des traitements cohérents
à moins d’imposer au système le fuseau UTC et de s’assurer qu’aucune commande
(telle SET TIME ZONE) ne vient compromettre cet état.

Pour cette raison, un futur sous-composant CoSQL_Tempus proposera une représentation
adéquate du temps (via le type TimePoint et ses dérivés) en le distinguant des
diverses conventions calendaires et en l’affranchissant des fuseaux horaires.

.Références
* https://www.bipm.org/fr/
* https://www.postgresql.org/docs/current/datatype-datetime.html
////
*/

create domain "Estampille"
  Timestamp with time zone
  -- constraint "Estampille_dom" check (extract(timezone from value) = 0)
  -- FIXED 2022-07-25 (LL01), 2021-11-05 (LL01) Vérifier si cette contrainte est (a) effective (b) non redondante.
  --  Exposé
  --    * Par le passé, la contrainte a été nécessaire pour éviter certaines erreurs de conversion.
  --    * Depuis la version 12 (au moins), elle n’est plus requise.
  --    * Sa présence aurait créé un problème de compatibilité en regard de certaines
  --      versions récentes du pilote JDBC, possiblement en lien certaines VM de Java
  --      (mais pas toutes).
  --  Réponse
  --    * La contrainte est redondante et il est préférable de la retirer.
  ;
comment on domain "Estampille" is $$
Meilleure approximation locale du point temporel, souvent Timestamp.
////
Sous PostgreSQL, la représentation et le calcul utilisent le type float8
(numérique flottant) ce qui entraine une imprécision relative et des erreurs
d’arrondis.
Pour une représentation discrète, voir le type "Timepoint" du sous-composant
CoSQL_Tempus ou du module "UHF".
////
$$;

create or replace function "gen_VT"("e" "Estampille") returns "Estampille"
  volatile
return
  cast(coalesce("e", current_timestamp) as "Estampille");
comment on function "gen_VT" ("Estampille") is $$
Temps de validation ; à défaut, on prend le temps de transaction
(donc current_timestamp et non clock_timestamp).
$$;

create or replace function "gen_TT"() returns "Estampille"
  volatile
return
  cast(current_timestamp as "Estampille");
comment on function "gen_TT" () is $$
Temps de transaction
(donc current_timestamp et non clock_timestamp).
$$;

create or replace function "gen_TC"() returns "Estampille"
  volatile
return
  cast(clock_timestamp() as "Estampille");
comment on function "gen_TC" () is $$
Temps courant selon l’horloge du processeur
(donc clock_timestamp et non current_timestamp).
$$;

create or replace function "estampille_chronon"() returns Interval
  immutable leakproof parallel safe
return
  Interval '0.000001';
comment on function "estampille_chronon" () is $$
Durée d’un chronon (en secondes).
$$;

create or replace function "estampille_min"() returns "Estampille"
  immutable leakproof parallel safe
return
  -- le cast est essentiel afin d'empêcher le décalage horaire intervenant lors
  -- d’une conversion implicite de timestamp vers timestamp with time zone
  cast ('4713-01-01 00:00:00.000000+00 BC' as "Estampille") ;
comment on function "estampille_min" () is $$
Estampille minimale.
$$;

create or replace function "estampille_max"() returns "Estampille"
  immutable leakproof parallel safe
return
  -- le cast est essentiel afin d'empêcher le décalage horaire intervenant lors
  -- d’une conversion implicite de timestamp vers timestamp with time zone
  cast ('294276-12-31 23:59:59.999999+00 AD' as "Estampille");
comment on function "estampille_max" () is $$
Estampille maximale.
$$;

create or replace function "estampille_ncs"() returns BigInt
  immutable leakproof parallel safe
return
  1000000;
comment on function "estampille_ncs" () is $$
Nombre de chronons dans une seconde.
$$;

/*
============================================================================== Z
CoSQL_Base_pub.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoSQL_def.sql
============================================================================== Z
*/
