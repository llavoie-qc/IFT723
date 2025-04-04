echo "---"
echo "*** DÉBUT de la production des documents du composant CoSQL ($(date -u +"%Y-%m-%d %H:%M:%S") UTC)"
echo " "

loc_outil=$rep_racine/CoLOED/AsciiDoc/script
loc_depot=$rep_racine/CoLOED/SQL
loc_source=$loc_depot/doc

$loc_outil/Asciidoc_gen.sh -d $loc_depot -o CoLOED -t -s $loc_source/CoSQL_SCL.adoc

echo " "
echo "*** FIN dde la production des documents du composant CoSQL ($(date -u +"%Y-%m-%d %H:%M:%S") UTC)"
echo "---"
