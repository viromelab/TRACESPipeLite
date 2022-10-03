#!/bin/bash
#
efetch -db nucleotide -format fasta -id NC_012920.1 > MT.fa
#
gto_fasta_extract_read_by_pattern -p "AY386330.1" < VDB.fa > B19.fa
gto_fasta_extract_read_by_pattern -p "MG921180.1" < VDB.fa > HPV.fa
gto_genomic_gen_random_dna -n 5000 | gto_fasta_from_seq -n "Synthetic-GTO-5k" > SYN.fa
#
gto_fasta_mutate -s 0 -e 0.002 < B19.fa   > B19_2.fa
gto_fasta_mutate -s 0 -e 0.003 < HPV.fa   > HPV_2.fa
#
cp B19_2.fa B19_A.fa
gto_fasta_mutate -s 0 -e 0.001 < B19_2.fa > B19_B.fa
gto_fasta_mutate -s 7 -e 0.001 < B19_2.fa > B19_C.fa
#
cp HPV_2.fa HPV_A.fa
gto_fasta_mutate -s 0 -e 0.01 < HPV_2.fa > HPV_B.fa
gto_fasta_mutate -s 0 -e 0.01 < HPV_2.fa > HPV_C.fa
#
cat SYN.fa B19_A.fa HPV_A.fa MT.fa > blood.fa
#
art_illumina -rs 0 -ss HS25 -sam -i blood.fa -p -l 150 -f 40 -m 200 -s 10 -o blood
#
