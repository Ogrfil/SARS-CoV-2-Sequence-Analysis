from Bio import SeqIO
import MySQLdb
import argparse
import re
from datetime import datetime

parser = argparse.ArgumentParser(description='Process fasta file and insert records into MySQL.')
parser.add_argument('fasta_files', type=str, nargs='+', help='Paths to the fasta files.')
args = parser.parse_args()

db = MySQLdb.connect(host="localhost", user="ip2", passwd="1234", db="sars_cov_2")
cursor = db.cursor()


for file_name in args.fasta_files:
	country = re.search(r'_([^_]+)_batch', file_name).group(1)
	with open(file_name) as f:
		br=1
		rbr=0
		for seq in SeqIO.parse(f,'fasta'):
			if br==1:
				custom_id = seq.id.split('|')[0]
				sequence = str(seq.seq)
				cursor.execute("SELECT MAX(rbr) FROM poravnato_clob_ref")
				result = cursor.fetchone()
				max_rbr = result[0] if result[0] is not None else 0
				rbr = max_rbr + 1
				cursor.execute("INSERT INTO poravnato_clob_ref (rbr, id, aligned_sequence, len) VALUES (%s, %s, %s, %s)", (rbr, custom_id, sequence, len(sequence)))
				db.commit()
				br=2
			elif br==2:
				custom_id, accession_id, date_str = seq.id.split('|')
				if len(date_str) == 7:
					date_str+= '-01'
				date = datetime.strptime(date_str,"%Y-%m-%d").date()
				sequence = str(seq.seq)
				cursor.execute("INSERT INTO poravnato_clob (rbr, id, accession_id, country, date, aligned_sequence, len) VALUES (%s, %s, %s, %s, %s, %s, %s)", (rbr, custom_id, accession_id, country, date, sequence, len(sequence)))
				db.commit()
				br=1
db.close()
