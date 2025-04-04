/*
////
============================================================================== A
CoSQL_Verif_pub.sql
------------------------------------------------------------------------------ A
Produit : CoSQL_Verif
Résumé : Sous-composant d’aide à la vérification de l’environnement SQL commun du CoLOED.
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
=== Gestion des tests et des assertions

Les routines de ce sous-composant ont pour but de faciliter et d’uniformiser
les tests des composants.
////
*/

create or replace function "test_identification" (test Text, partie Text) returns Text
  volatile
return
  '*** % ' || test || ' - ' || partie || ' : ' || "gen_TC" () || ' UTC % ***' ;
comment on function "test_identification" is $$
////
."test_identification" (test Text, partie Text) : Text;

Dénotation uniforme horodatée (UTC) et textuellement affichable d’un test
(ou d’une partie d’un test)
////
$$;

create or replace procedure "Asserter"(
  message Text,
  predicat Boolean
)
  language plpgsql as
$$
begin
  if not predicat then
    raise exception '*** %', ('ERR : ' || message) ;
  end if;
end
$$;
comment on procedure "Asserter" is $$
////
."Asserter" (message Text, predicat Boolean);

* Si le prédicat est vrai, ne fait rien.
* Si le prédicat est faux, signale une exception comprenant le message préfixé par ERR.
////
$$;

create or replace function "test"(
  message Text,
  predicat Boolean
)
  returns Boolean
  volatile
  language plpgsql as
$$
declare
  mes_complet Text ;
begin
  mes_complet := (case when predicat then 'POS : ' else 'NEG : ' end) || message;
  if predicat then
    raise notice  '*** %', mes_complet ;
  else
    raise warning '*** %', mes_complet ;
  end if;
  return predicat ;
end
$$;
comment on function "test" is $$
////
."test" (message Text, predicat Boolean) : Boolean;

* Si le prédicat est vrai, signale une note (NOTICE) comprenant le message préfixé par POS.
* Si le prédicat est faux, signale un avertissement (WARNING) comprenant le message préfixé par NEG.
* Retourne la valeur du prédicat.
////
$$;

create or replace procedure "Manifester"(
  message Text,
  predicat Boolean
)
  language plpgsql as
$$
declare
  b Boolean ;
begin
  b := "CoSQL"."test" (message, predicat) ;
end
$$;
comment on procedure "Manifester" is $$
////
."Manifester" (message Text, predicat Boolean);

* Si le prédicat est vrai, signale une note (NOTICE) comprenant le message préfixé par POS.
* Si le prédicat est faux, signale un avertissement (WARNING) comprenant le message préfixé par NEG.
////
$$;

create or replace procedure "Asserter_exception"(
  message Text,
  instruction Text
)
  language plpgsql as
$$
declare
  detection Boolean := true ;
begin
  execute instruction  ;
  detection := false ;
  raise exception 'CoSQL_Asserter_exception_detection_echec' ;
exception
  when others then
    if not detection then
      raise exception '*** %', ('ERR : ' || message || ' -> ' || instruction) ;
    end if;
end
$$;
comment on procedure "Asserter_exception" is $$
////
."Asserter_exception" (message Text, instruction Text);

* Si l’instruction lève une exception, la neutralise et ne fait rien d’autre.
* Si l’instruction ne lève pas d’exception, signale une exception comprenant
  le message préfixé par ERR.
////
$$;

create or replace function "test_exception"(
  message Text,
  instruction Text
)
  returns Boolean
  volatile
  language plpgsql as
$$
declare
  mes_complet Text ;
  detection Boolean := true ;
begin
  execute instruction  ;
  detection := false ;
  raise exception 'CoSQL_Test_exception_detection_echec' ;
exception
  when others then
    mes_complet := (case when detection then 'POS : ' else 'NEG : ' end) || message;
    if detection then
      raise notice  '*** %', mes_complet ;
      return true ;
    else
      raise warning '*** %', mes_complet ;
      return false ;
    end if;
end
$$;
comment on function "test_exception" is $$
////
."test_exception" (message Text, instruction Text) : Boolean;

* Si l’instruction lève une exception, la neutralise, signale une note (NOTICE)
  comprenant le message préfixé par POS puis retourne vrai.
* Si l’instruction ne lève pas d’exception, signale un avertissement (WARNING)
  comprenant le message préfixé par NEG puis retourne faux.
////
$$;

create or replace procedure "Manifester_exception"(
  message Text,
  instruction Text
)
  language plpgsql as
$$
declare
  b Boolean ;
begin
  b := "CoSQL"."test_exception" (message, instruction) ;
end
$$;
comment on procedure "Manifester_exception" is $$
////
."Manifester_exception" (message Text, instruction Text) : Boolean

* Si l’instruction lève une exception, la neutralise puis signale une note (NOTICE)
  comprenant le message préfixé par POS.
* Si l’instruction ne lève pas d’exception, signale un avertissement (WARNING)
  comprenant le message préfixé par NEG.
////
$$;

/*
============================================================================== Z
CoSQL_Verif_pub.sql
------------------------------------------------------------------------------ Z
Contributeurs, droits, licences... : voir CoSQL_def.sql
============================================================================== Z
*/
