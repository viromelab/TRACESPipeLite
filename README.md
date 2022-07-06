# TRACESPipeLite

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](LICENSE)
[![Speed](https://img.shields.io/static/v1.svg?label=Ultra-Fast&message=Ultra%20speed%20performance&color=green)](#)
[![Release](https://img.shields.io/static/v1.svg?label=Release&message=v1.0&color=orange)](#)

TRACESPipeLite is the reference-based version of TRACESPipe. TRACESPipeLite is oriented for human viral genome classification, specifically to apply directly in clinical virology backgrounds. It provides the ultra-fast reconstruction of viral genomes while automatically generating consensus sequences, breadth and depth coverage values and profiles, and others. The viral database is freely provided. Assembly is exclusively reference-based and can be used in the provided database, but not limited.

## 1. Installation ##

To install TRACESPipeLite, please run
```
git clone https://github.com/viromelab/TRACESPipeLite.git
cd TRACESPipeLite/src/
lzma -d VDB.fa.lzma
chmod +x *.sh
./TRACESPipeLite.sh --install
```

## 2. Database build and quality check (optional) ##

An extensive and high-quality database is fundamental for high accuracy in metagenomic classification. 
TRACESPipeLite already includes a database at the src directory, with the name VDB.fa.lzma.
Nevertheless, the following procedure includes instructions on how to create and check the quality of a specific database with the following 55 viruses and Human mitogenome:
```
B19V		Human Parvovirus
BuV 		Bufa virus
CuV 		Cuta virus
HBoV 		Boca virus type 1
AAV		Adeno-Associated Virus
BKPyV	 	Human polyomavirus 1
JCPyV 		Human polyomavirus 2
KIPyV 		Human polyomavirus 3
WUPyV 		Human polyomavirus 4
MCPyV		Human polyomavirus 5 
HPyV6	  	Human polyomavirus 6
HPyV7	 	Human polyomavirus 7
TSPyV	 	Human polyomavirus 8
HPyV9	 	Human polyomavirus 9
MWPyV	 	Human polyomavirus 10
STLPyV 		Human polyomavirus 11
HPyV12 		Human polyomavirus 12
NJPyV	 	Human polyomavirus 13
LIPyV	 	Human polyomavirus 14
SV40		Simian virus 40
TTV		Torque Teno Virus
HAV 		Hepatitis A Virus
HBV 		Hepatitis B Virus
HCV 		Hepatitis C Virus
HDV 		Hepatitis D Virus
HEV		Hepatitis E Virus
SENV    	SEN virus
HPV2		Human papillomavirus 2
HPV6	 	Human papillomavirus 6
HPV11 		Human papillomavirus 11
HPV16 		Human papillomavirus 16
HPV18 		Human papillomavirus 18
HPV31 		Human papillomavirus 31
HPV39 		Human papillomavirus 39
HPV45 		Human papillomavirus 45
HPV51 		Human papillomavirus 51
HPV56 		Human papillomavirus 56
HPV58 		Human papillomavirus 58
HPV59 		Human papillomavirus 59
HPV68 		Human papillomavirus 68
HPV77		Human papillomavirus 77
HSV-1	 	Herpes-Simplex Virus 1
HSV-2 		Herpes-Simplex Virus 2
VZV 		Varicela-Zoster Virus
EBV 		Epstein-Barr virus
HCMV	 	Human Cytomegalovirus
HHV6		Human Herpesvirus 6
HHV7 		Human Herpesvirus 7
KSHV		Kaposi's Sarcoma-associated Herpesvirus
ReDoV	 	Redondovirus
VARV 		Variola Virus
MPXV		Monkeypox Virus
EV		Enterovirus 
SARS2		SARS-CoV-2
HERV 		Human Endogenous Retrovirus
MT   	        Human Mitogenome
```
To download, build, and create the PDF with the respective quality controls, for each virus, there will be the need to create a file in IDS/ as
```
ID-<virus_name>.ids
```
containing the IDs (one for each line) for the respective virus type.

After, there will be the need to run:
```
./TRACESCreateDB.sh
./TRACESAnalyzeDB.sh
./TRACESMergeDB.sh
```
The output will be available as
```
FIL-DB-<virus_name>.mfa
Composition-<virus_name>.pdf
```
and the whole FASTA database as
```
VDB.mfa
```
Finally, to set this viral database as default, type:
```
mv VDB.mfa VDB.fa
```

## 3. Running example ##

The TRACESPipeLite package includes viral reads for a quick demonstration.
To run the example, please, first, install the tool. Then, run the following command
```
./TRACESPipeLite.sh --threads 8 --reads1 reads_forward.fq.gz \
--reads2 reads_forward.fq.gz --database VDB.fa --output test_viral_analysis
```

## 4. Usage ##

To see the option of TRACESPipeLite, please run the following command
```
./TRACESPipeLite.sh -h
```
This command will output the following content
```
 -------------------------------------------------------- 
                                                          
 TRACESPipeLite.sh : TRACESPipe lite version v1.0         
                                                          
 This is a lite version of TRACESPipe. It provides        
 automatic reconstruction (reference-based only) of       
 viral genomes and performs basic analyses.               
                                                          
 Program options ---------------------------------------- 
                                                          
 -h, --help                     Show this,                
 -i, --install                  Installation (w/ conda),  
                                                          
 -lg <INT>, --log-scale <INT>   Coverage log scale,       
 -ws <INT>, --window <INT>      Coverage window size,     
 -dr <INT>, --drop <INT>        Coverage drop size,       
 -cx <INT>, --start <INT>       Coverage start x-axis,    
 -ma <INT>, --maximum <INT>     Coverage maximum (crop),  
 -si <INT>, --similarity <DBL>  Minimum similarity for    
                                applying reconstruction,  
 -t  <INT>, --threads <INT>     Number of threads,        
 -o  <STR>, --output <STR>      Output folder name,       
                                                          
 -r1 <STR>, --reads1 <STR>      FASTQ reads (forward),    
 -r2 <STR>, --reads2 <STR>      FASTQ reads (reverse),    
                                                          
 -db <STR>, --database <STR>    FASTA Viral Database.     
                                                          
 Example -----------------------------------------------  
                                                          
 TRACESPipeLite.sh --reads1 reads_forward.fq.gz \        
   --reads2 reads_reverse.fq.gz --database VDB.fa \      
   --output lite_viral_analysis --threads 8               
                                                          
 -------------------------------------------------------
```

## 5. Citation ##

Please, cite:
```
Pratas, D., Toppinen, M., Pyöriä, L., Hedman, K., Sajantila, A. and Perdomo, M.F., 2020. 
A hybrid pipeline for reconstruction and analysis of viral genomes at multi-organ level.
GigaScience, 9(8), p.giaa086.
```
[PDF Link](https://doi.org/10.1093/gigascience/giaa086)

## 6. License ##

GPL v3.

For more information see LICENSE file or visit
<pre>http://www.gnu.org/licenses/gpl-3.0.html</pre>



