#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Greška: Očekuje se tačno jedan argument."
    echo "Upotreba: $0 putanja_do_fasta_fajla"
    exit 1
fi

FASTA_FILE="$1"
FILE_NAME=$(basename "$FASTA_FILE")

if [ ! -f "$FASTA_FILE" ]; then
    echo "Greška: Datoteka '$FASTA_FILE' ne postoji."
    exit 2
fi

OUTPUT_FILE="Podaci/aligned/${FILE_NAME}_aligned.fasta"

echo "" > $OUTPUT_FILE;

REF_SEQ=$(awk '/^>/ {if (header) {exit}; header=1; print; next} {print}' "$FASTA_FILE")
echo "$REF_SEQ" > "combined_sequence.fasta";

aligned_count=0;
total_count=$(awk '/^>/ {count++} END {print count-1}' "$FASTA_FILE");

awk -v aligned_count="$aligned_count" -v total_count="$total_count" -v ref_seq="$REF_SEQ" -v output_file="$OUTPUT_FILE" 'BEGIN {RS=">"; FS="\n"; ORS=""; first_sequence_skipped=0} NR > 1 && NF > 1 {
	if (!first_sequence_skipped) {
		first_sequence_skipped = 1;
    	next;
    }
    current_seq = ">" $0;
    print current_seq >> "combined_sequence.fasta";
    aligned_count++;
    print aligned_count "/" total_count "\n";
    system("cat combined_sequence.fasta");
    system("./clustalo -i combined_sequence.fasta --force --seqtype=DNA --full --outfmt=fasta --wrap=60 >> " output_file);

    system("echo \x27" ref_seq "\x27 > combined_sequence.fasta");
    
}' "$FASTA_FILE"

echo "Poravnavanje završeno. Sve poravnate sekvence su u fajlu: $OUTPUT_FILE"

