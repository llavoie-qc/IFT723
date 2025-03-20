/** ==================================================
Create the schema
====================================================== */
-- create database "Supplier-Part";
-- Add Gist extension
create extension if not exists "btree_gist";
-- Create the schema
drop schema if exists "supplier-part_uhf" cascade;
create schema uhf
  authorization postgres;
  grant all on schema "supplier-part_uhf" to postgres;
comment on schema "supplier-part_uhf" is
  'Schema as UFH for the example in the Date, C.J., Darwen, H., Lorentzos, N.A. Book'
  'Time and relational theory: temporal databases in the relational model and SQL. (2014)';

set schema 'supplier-part_uhf';
/** ==================================================
Author : Christina.Khnaisser@usherbrooke.ca
Last modified : 2020-02-10
Creation date : 2017-06-27
RDBMS : PostgreSQL 9.5+
====================================================== */