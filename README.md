# SARS-CoV-2-Sequence-Analysis

Skup ulaznih podataka sadrzi:

- sekvence SARS-CoV-2 virusa i odgovarajuce metapodatke izdvojene iz baze GISAID (https://gisaid.org/) uz koriscenje opcija Complete i High Coverage. Sekvence izabrati iz uzoraka sa teritorije sledecih zemalja: Madjarske, Grcke, Hrvatske, Japana i Srbije.
- referentnu sekvencu SARS-CoV-2 virusa (NCBI identifikacija NC_045512.2) i odgovarajuce metapodatke.

1. Poravnati nukleotidne sekvence u odnosu na referentni izolat. Za tako poravnate sekvence odrediti moguce granice proteina u sekvencama izdvojenim iz GISAID baze.

2. Odrediti procenat identicnih sekvenci za svaki mesec od marta 2020. do januara 2023. godine, za svaki moguci par zemalja (Madjarska-Grcka, Madjarska-Hrvatska...).

3. Odrediti procenat razlicitih sekvenci za svaki mesec pocevsi od marta 2020. do januara 2023. godine, za svaki moguci par zemalja (Madjarska-Grcka, Madjarska-Hrvatska...) u zavisnosti od broja pozicija na kojima se nalaze razliciti nukleotidi. Tabelu prikazati po (prethodno odredjenim) proteinima.

4. Odrediti procenat unikatnih sekvenci koje su prisutne u ukupnim uzorcima iz Srbije u odnosu na ukupan broj uzoraka za svaku od ostale 4 zemlje. Tabelu prikazati po (prethodno odredjenim) proteinima.

5. Za uzorke iz perioda 1.3.2020-1.4.2021 godine i period 1.12.2022-1.1.2023. odrediti koji najduzi niz nukleotida je identican za uzorke iz Srbije i Japana i kojim proteinima pripadaju pronadjeni nizovi.

---

 - Tabela za originalne podatke pravi se pomocu sql skripte sequence_table.sql
 - Sekvence se ubacuju u tabelu pomocu python skripte load_sequence.py "python3 load_sequence.py"
 - Proceduru za racunanje identicnih sekvenci Calc_identical() dobijamo iz calc_identical.sql. Pozivamo proceduru Calc_identical().
 - Glavnim fasta fajlovima dodaje se referentni genom na vrh 
   (kako bi poravnanje.sh skripta radila ispravno) pokretanjem skripte add_ref_to_fasta.sh sa: "./add_ref_to_fasta.sh".
 - Dalje se vrsi uzorkovanje i izbacivanje duplikata python skriptom sample_rmdup_modheader.py: "python3 sample_rmdup_modheader.py"
 - Fajlovi se dele na manje delove sa batches_with_ref.py "python3 batches_with_ref.py"
 - Poravnanje vrsi se skriptom poravnanje.sh koja se poziva na sledeci nacin: "./poravnanje.sh path_to_fasta". 
   Path_to_fasta je npr "Podaci/batches_with_ref/sample_rmdup_modheader_grcka_batch_1.fasta". 
   Ako zelimo da izvrsimo poravnanje za vise fajlova koristimo poravnanje_multiple.sh koje pozivamo sa nizom fajlova. 
 - Tabele poravnato_clob i poravnato_clob_ref dobijamo pokretanjem sql skripte aligned_table.sql
 - Poravnate podatke ubacujemo u bazu sa load_poravnato.py "python3 load_poravnato paths_to_aligned_files"
 - Tabele granice_proteini i protein_kod_sekv pravimo skriptom protein_table.sql
 - Granice za proteine ubacujemo sa load_granice.py "python3 load_granice.py"
 - Dalje pokrecemo skriptu proteini.sql
 - Za protein kodirajuce sekvence pozivamo sql proceduru pronadji_proteine()
 - Tabelu za kombinacije zemalja popunjavamo sql skriptom kombinacije_zemalja.sql
 - Tabele razlike_proteina i percentage_results dobijamo sql skriptom razlicite_table.sql
 - Procedure CalculateDifferent() i CalculatePercentage() dobijamo iz skripte razlicite.sql i njih pozivamo za 3. zadatak
 - Tabelu unikatne_procenti_srbija dobijamo iz unikatne_table.sql
 - Proceduru CalculateUniquePercentage() dobijamo iz unikatne.sql i nju pozivamo
 - Tabelu lcs_srbija_japan pravimo sa skriptom longest_table.sql
 - Lcs racunamo i ubacujemo u bazu pozivanjem python skripte lcs.py "python3 lcs.py"
