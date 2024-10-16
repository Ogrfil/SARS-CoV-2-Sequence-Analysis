from Bio import SeqIO
import random
import os

def sample_and_modify_headers(fasta_files, num_samples=1000, output_dir="Podaci/modified_samples"):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    for fasta_file in fasta_files:
        all_sequences = list(SeqIO.parse(fasta_file, "fasta"))

        unique_sequences_by_str = set(str(seq.seq) for seq in all_sequences)
        unique_sequences = []
        seen_sequences = set()
        for seq in all_sequences:
        	seq_str = str(seq.seq)
        	if seq_str not in seen_sequences:
        		unique_sequences.append(seq)
        		seen_sequences.add(seq_str)
        		
        if len(unique_sequences) < num_samples:
            print(f"Upozorenje: {fasta_file} sadrži samo {len(unique_sequences)} jedinstvenih sekvenci.")
            sampled_sequences = unique_sequences
        else:
            sampled_sequences = random.sample(unique_sequences, num_samples)
        
        modified_sequences = []
        for seq in sampled_sequences:
            parts = seq.id.split('/')
            year = parts[-1].split('|')[0]
            new_id = parts[2] + ".1"
            additional_info = '|'.join(seq.id.split('|')[1:])
            new_desc = '|'.join([new_id] + [additional_info])
            seq.id = new_desc
            seq.description = ''

            modified_sequences.append(seq)
        
        output_path = os.path.join(output_dir, f"sample_rmdup_modheader_{os.path.basename(fasta_file)}")
        SeqIO.write(modified_sequences, output_path, "fasta")
        print(f"Završeno uzorkovanje i modifikacija za {fasta_file}. Rezultati sačuvani u {output_path}.")

fasta_files = ['Podaci/srbija/srbija.fasta', 'Podaci/madjarska/madjarska.fasta', 'Podaci/grcka/grcka.fasta', 'Podaci/hrvatska/hrvatska.fasta', 'Podaci/japan/japan.fasta']

sample_and_modify_headers(fasta_files)

