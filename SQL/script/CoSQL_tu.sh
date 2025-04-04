echo "---"
echo "*** DÉBUT des tests du composant CoSQL ($(date -u +"%Y-%m-%d %H:%M:%S") UTC)"
echo " "

hote="localhost"
port="5432"
bdc="CoLOED"
rep_source_temp="./SQL/src/sql"
rep_test_temp="./SQL/test/sql"

psql -h "${hote}" -p "${port}" -d "${bdc}" -v s="${rep_source_temp}" -v t="${rep_test_temp}"<<EOF
-- \i :t/010_CoSQL_Base_co.sql
-- \i :t/010_CoSQL_Base_ex.sql
\i :t/010_CoSQL_Base_tu.sql
-- \i :t/010_CoSQL_IMEX_ex.sql
-- call "Parametre_interne_definir" ("parametre_importation" (), '/Users/Shared/DGS/CoLOED/SQL/temp/test/', 'Pour LL');
-- call "Parametre_interne_definir" ("parametre_exportation" (), '/Users/Shared/DGS/CoLOED/SQL/temp/test/', 'Pour LL');
\i :t/010_CoSQL_IMEX_tu.sql
EOF

echo " "
echo "*** FIN des tests du composant CoSQL ($(date -u +"%Y-%m-%d %H:%M:%S") UTC)"
echo "---"
