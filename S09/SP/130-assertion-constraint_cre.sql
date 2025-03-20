/** ==================================================
Create the assertion constraints
====================================================== */
set search_path to "supplier-part_uhf", "UHF";
---------------- KEY s_during ----------------
-- Redundancy
alter table s_during
  add constraint s_during_redundancy_check
    exclude using gist (sno with =, during with &&);
comment on constraint s_during_redundancy_check on s_during is 'Check redundancy constraint';
-- Circumlocution
alter table s_during
  add constraint s_during_circumlocution_check
    exclude using gist (sno with =, during with -|-);
comment on constraint s_during_circumlocution_check on s_during is 'Check circumlocution constraint';
------ Contradiction
-- NA
---------------- Attribute s_status_during ----------------
-- Redundancy
alter table s_status_during
  add constraint s_status_during_redundancy_check
    exclude using gist (sno with =, status with =, during with &&);
-- Circumlocution
alter table s_status_during
  add constraint s_status_during_circumlocution_check
    exclude using gist (sno with =, status with =, during with -|-);
-- Contradiction
alter table s_status_during
  add constraint s_status_during_contradiction_check
    exclude using gist (sno with =, status with <>, during with &&);
---------------- KEY sp_during ----------------
-- Redundancy
alter table sp_during
  add constraint sp_during_redundancy_check
    exclude using gist (sno with =, pno with =, during with &&);
-- Circumlocution
alter table sp_during
  add constraint sp_during_circumlocution_check
    exclude using gist (sno with =, pno with =, during with -|-);
------ Contradiction
-- NA
--
/** ==================================================
Author : Christina.Khnaisser@usherbrooke.ca
Last modified : 2020-02-10
Creation date : 2017-06-27
RDBMS : PostgreSQL 9.5+
====================================================== */