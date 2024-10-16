from Bio import SeqIO
import MySQLdb
from datetime import datetime

fasta_files = ['Podaci/srbija/srbija.fasta', 'Podaci/madjarska/madjarska.fasta', 'Podaci/grcka/grcka.fasta', 'Podaci/hrvatska/hrvatska.fasta', 'Podaci/japan/japan.fasta']
#fasta_files = ['Podaci/japan/japan.fasta']

db = MySQLdb.connect(host="localhost", user="ip2", passwd="1234", db="sars_cov_2")
cursor = db.cursor()

for fasta_file in fasta_files:
	all_sequences = list(SeqIO.parse(fasta_file, "fasta"))
	country = fasta_file.split('/')[1]  		      
	for seq in all_sequences:
		parts = seq.id.split('/')
		custom_id = parts[2] + ".1"
		accession_id, date_str = seq.id.split('|')[1:]
		if len(date_str) == 7:
			date_str+= '-01'
		date = datetime.strptime(date_str,"%Y-%m-%d").date()
		sequence = str(seq.seq)
		cursor.execute("INSERT INTO sekvence (id, accession_id, country, date, sequence, len) VALUES (%s, %s, %s, %s, %s, %s)", (custom_id, accession_id, country, date, sequence, len(sequence)))
		db.commit()
			
db.close()
