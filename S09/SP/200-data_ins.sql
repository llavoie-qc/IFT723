/** ==================================================
Create a valid dataset
====================================================== */
set schema 'supplier-part_uhf';
-- =========================== SINCE
insert into s_since(sno, since) values
  ('S1', 4),
  ('S2', 7),
  ('S3', 3),
  ('S4', 4),
  ('S5', 2),
  -- extra
  ('S9', 5),
  ('S10', 10)
;
insert into s_status_since(sno, status, since) values
  ('S1', 20, 6),
  ('S2', 10, 7),
  ('S3', 30, 3),
  ('S4', 20, 8),
  ('S5', 30, 2),
  -- extra
  ('S9', 9, 5),
  ('S10', 10, 11)
;
insert into sp_since(sno, pno, since) values
  ('S1', 'P1', 4),
  ('S1', 'P2', 5),
  ('S1', 'P3', 9),
  ('S1', 'P4', 5),
  ('S1', 'P5', 4),
  ('S1', 'P6', 6),
  ('S2', 'P1', 8),
  ('S2', 'P2', 9),
  ('S3', 'P2', 8),
  ('S4', 'P5', 5)
;
-- =========================== DURING
insert into s_during(sno, during) values
  ('S2', '[2,4]'),
  ('S6', '[3,5]'),
  -- extra
  ('S8', '[5,7]'),
  ('S10', '[6,7]')
;
insert into s_status_during(sno, status, during) values
  ('S1', 15, '[4,5]'),
  ('S2', 5,  '[2,2]'),
  ('S2', 10, '[3,4]'),
  ('S4', 10, '[4,4]'),
  ('S4', 25, '[5,7]'),
  ('S6', 5,  '[3,4]'),
  ('S6', 7,  '[5,5]'),
  -- extra
  ('S8', 30,  '[5,7]'),
  ('S10', 20,  '[6,7]'),
  ('S10', 30,  '[10,10]')
;
insert into sp_during(sno, pno, during) values
  ('S2', 'P1', '[2,4]'),
  ('S2', 'P2', '[3,3]'),
  ('S3', 'P5', '[5,7]'),
  ('S4', 'P2', '[6,9]'),
  ('S4', 'P4', '[4,8]'),
  ('S6', 'P3', '[3,3]'),
  ('S6', 'P3', '[5,5]')
;
-- =========================== UNTIL
insert into s_until(sno, until) values
  ('S7', 8),
  ('S8', 2),
  ('S9', 3),
  ('S10', 4)
;
insert into s_status_until(sno, status, until) values
  ('S7', 7, 8),
  ('S8', 8, 2),
  ('S9', 10, 3),
  ('S10', 12, 4)
;
insert into sp_until(sno, pno, until) values
  ('S7', 'P1', 8),
  ('S8', 'P1', 2),
  ('S9', 'P1', 3)
;
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