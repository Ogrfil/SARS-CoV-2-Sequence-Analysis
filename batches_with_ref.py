from Bio import SeqIO
import os

def create_batches(fasta_file, ref_seq_file, output_dir, batch_size=200):
    with open(ref_seq_file, "r") as ref_file:
        ref_seq = next(SeqIO.parse(ref_file, "fasta"))
    sequences = list(SeqIO.parse(fasta_file, "fasta"))

    num_batches = len(sequences) // batch_size + (1 if len(sequences) % batch_size else 0)
    
    for i in range(num_batches):
        batch_sequences = [ref_seq] + sequences[i*batch_size:(i+1)*batch_size]
        
        output_filename = os.path.basename(fasta_file).replace(".fasta", f"_batch_{i+1}.fasta")
        output_filepath = os.path.join(output_dir, output_filename)
        
        SeqIO.write(batch_sequences, output_filepath, "fasta")
        print(f"Batch {i+1} saved to {output_filepath}")

ref_seq_file = "Podaci/NC_045512.2.fna"

countries = ['srbija', 'madjarska', 'grcka', 'hrvatska', 'japan']

output_dir = "Podaci/batches_with_ref"
os.makedirs(output_dir, exist_ok=True)

for country in countries:
    fasta_file = f"Podaci/modified_samples/sample_rmdup_modheader_{country}.fasta"
    create_batches(fasta_file, ref_seq_file, output_dir)

