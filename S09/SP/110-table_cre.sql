/** ==================================================
Create the tables
====================================================== */
set search_path to "supplier-part_uhf", "UHF";
-- =========================== SINCE - Vbx
create table s_since
(
  sno CHAR(3) not null,
  since "UHF"."Point" not null,
  constraint s_since_ck0 primary key (sno)
);

create table s_status_since
(
  sno CHAR(3) not null,
  status INT not null,
  since "UHF"."Point" not null,
  constraint s_status_since_ck0 primary key (sno),
  constraint s_status_since_fk0 foreign key (sno) references s_since(sno)
);

create table sp_since
(
  sno CHAR(3) not null,
  pno CHAR(3) not null,
  since "UHF"."Point" not null,
  constraint sp_since_ck0 primary key (sno, pno),
  constraint sp_since_fk0 foreign key (sno) references s_since(sno)
);
-- =========================== DURING - Vbe
-- Atention ! Les contraintes sont vraies, mais insuffisantes.
-- Voir 120-index_cre.sql et 130_assertion_constraint.sql
create table s_during
(
  sno CHAR(3) not null,
  during "UHF"."Interval" not null,
  constraint s_during_ck0 primary key (sno, during)
);

create table s_status_during
(
  sno CHAR(3) not null,
  status INT not null,
  during "UHF"."Interval" not null,
  constraint s_status_during_ck0 primary key (sno, during)
);

create table sp_during
(
  sno CHAR(3) not null,
  pno CHAR(3) not null,
  during "UHF"."Interval" not null,
  constraint sp_during_ck0 primary key (sno, pno, during)
);

/** ==================================================
Author : Christina.Khnaisser@usherbrooke.ca
Last modified : 2020-02-10
Creation date : 2017-06-27
RDBMS : PostgreSQL 9.5+

Reference:
  Date, Chris J., Hugh Darwen, et Nikos A. Lorentzos. (2014)
  Time and Relational Theory: Temporal Databases in the Relational Model and SQL.
  Waltham, MA: Morgan Kaufmann. Chap.14 p.269-270
====================================================== */