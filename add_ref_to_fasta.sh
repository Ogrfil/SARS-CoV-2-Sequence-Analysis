#!/bin/bash

refSeq="NC_045512.2.fna"

countries=("grcka" "hrvatska" "japan" "madjarska" "srbija")

for country in "${countries[@]}"
do
    echo "Dodavanje referentne sekvence u $country.fasta..."
    cat "Podaci/$refSeq" "Podaci/${country}/${country}.fasta" > "Podaci/added_ref/temp_${country}.fasta"
    echo "Završeno dodavanje za $country.fasta."
done

echo "Dodavanje referentne sekvence završeno za sve fajlove."
