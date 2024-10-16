#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo "Greška: Očekuje se barem jedan argument."
    echo "Upotreba: $0 putanja_do_fasta_fajla1 [putanja_do_fasta_fajla2 ...]"
    exit 1
fi

for FASTA_FILE in "$@"; do
    if [ ! -f "$FASTA_FILE" ]; then
        echo "Greška: Datoteka '$FASTA_FILE' ne postoji."
        continue
    fi
    
    ./poravnanje.sh "$FASTA_FILE"
done

