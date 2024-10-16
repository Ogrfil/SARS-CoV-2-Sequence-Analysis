import MySQLdb

db = MySQLdb.connect(host="localhost", user="ip2", passwd="1234", db="sars_cov_2")
cursor = db.cursor()

def find_longest_common_substring(seqs):
	if not seqs:
		return "", -1, -1
    
	seq_count = len(seqs)
	seq_len = len(seqs[0])
	lcs = ""
	left_pos = -1
	right_pos = -1
    
	for start in range(seq_len):
		for end in range(start + 1, seq_len + 1):
			substr = seqs[0][start:end]
			if all(seq[start:end] == substr and '_' not in seq[start:end] for seq in seqs):
				if len(substr) > len(lcs):
					lcs = substr
					left_pos = start
					right_pos = end - 1
	return lcs, left_pos, right_pos

periods = [("2020-03-01", "2021-04-01"), ("2022-12-01", "2023-01-01")]

for start_date, end_date in periods:
	query = f"SELECT aligned_sequence FROM poravnato_clob WHERE country IN ('srbija', 'japan') AND date BETWEEN %s AND %s"
	cursor.execute(query, (start_date, end_date))
	sequences = [row[0] for row in cursor.fetchall()]

	lcs, left_pos, right_pos = find_longest_common_substring(sequences)
            
	insert_query =f"INSERT INTO lcs_srbija_japan (start_date, end_date, leva_granica, desna_granica, lcs) VALUES (%s, %s, %s, %s, %s)"
	cursor.execute(insert_query, (start_date, end_date, left_pos, right_pos, lcs))
	db.commit()

cursor.close()
db.close()

