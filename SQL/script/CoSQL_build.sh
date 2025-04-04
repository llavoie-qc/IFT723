echo "---"
echo "*** DÉBUT de la construction du composant CoSQL ($(date -u +"%Y-%m-%d %H:%M:%S") UTC)"
echo " "

hote="localhost"
port="5432"
bdc="CoLOED"
rep_script_temp="./SQL/script"
rep_source_temp="./SQL/src/sql"
rep_test_temp="./SQL/test/sql"

psql -h "${hote}" -p "${port}" -d "${bdc}" -v s="${rep_source_temp}" -v t="${rep_test_temp}"<<EOF
\i :s/001_CoSQL_def.sql
\i :s/010_CoSQL_Base_ini.sql
\i :s/011_CoSQL_Base_pub.sql
\i :s/012_CoSQL_Base_pub-rel.sql
\i :s/015_CoSQL_Verif_ini.sql
\i :s/016_CoSQL_Verif_pub.sql
\i :s/017_CoSQL_Verif_pub.obs.sql
\i :t/010_CoSQL_Base_tu.sql
\i :s/020_CoSQL_Param_ini.sql
\i :s/021_CoSQL_Param_pri.sql
\i :s/022_CoSQL_Param_pub.sql
\i :s/030_CoSQL_IMEX_ini.sql
\i :s/031_CoSQL_IMEX_pub.sql
\i :s/032_CoSQL_IMEX_pub-par.sql
call "Parametre_interne_definir" ("parametre_importation" (), '/Users/Shared/DGS/CoLOED/SQL/temp/test/', 'Pour LL');
call "Parametre_interne_definir" ("parametre_exportation" (), '/Users/Shared/DGS/CoLOED/SQL/temp/test/', 'Pour LL');
\i :t/030_CoSQL_IMEX_tu.sql
EOF

echo " "
echo "*** FIN de la construction du composant CoSQL ($(date -u +"%Y-%m-%d %H:%M:%S") UTC)"
echo "---"
