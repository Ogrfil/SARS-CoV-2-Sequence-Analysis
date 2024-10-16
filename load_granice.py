import MySQLdb

db = MySQLdb.connect(
    host="localhost",
    user="ip2",
    passwd="1234",
    db="sars_cov_2"
)

cursor = db.cursor()

with open('Podaci/granice_proteini.txt', 'r') as file:
    lines = file.readlines()

for line in lines:
    parts = line.strip().split(',')
    leva_granica = int(parts[0]),
    desna_granica = int(parts[1])
    protein = parts[2]
    accession_prot = parts[3]

    cursor.execute("INSERT INTO granice_proteini (leva_granica, desna_granica, protein, accession_prot) VALUES (%s, %s, %s, %s)", (leva_granica, desna_granica, protein, accession_prot))

db.commit()

cursor.close()
db.close()

