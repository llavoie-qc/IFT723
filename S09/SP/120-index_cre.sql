/** ==================================================
Create indexes
====================================================== */
set search_path to "supplier-part_uhf", "UHF";
--
create index s_during_idx
  on s_during using GIST (sno, during);
--
create index s_status_idx
  on s_status_during using GIST (sno, during);
--
create index sp_during_idx
  on sp_during using GIST (sno, pno, during);
--
/** ==================================================
Author : Christina.Khnaisser@usherbrooke.ca
Last modified : 2022-02-14
Creation date : 2022-02-14
RDBMS : PostgreSQL 9.5+

https://www.postgresql.org/docs/13/rangetypes.html#RANGETYPES-CONSTRAINT
====================================================== */