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
Nevertheless, the following procedure includes instructions on how to create and check the quality of a specific database with the following 42 human viruses:
```
B19V
BufaV
HBV
HHV7
HPV16
HPV31
HPV51
HPV59
HPV77
HPyV6
HSV-1
KI
NJPyV
TTV
BKpV
CutaV
HCMV
HHV8
HPV18
HPV39
HPV56
HPV68
HPyV10
HPyV7
HSV-2
LIPyV
STLPyV
VZV
BocaV
EBV
HHV6
HPV11
HPV2
HPV45
HPV58
HPV6
HPyV12
HPyV9
JCV
MCPyV
TSPyV
WUHPyV
```
To download, build, and create the PDF with the respective quality controls, for each viruses, there will be the need to create a file as
```
<virus_name>.txt
```
containing the IDs (one for each line) for the respective virus type.

After, there will be the need to run:
```
./RunDB.sh
```
The output will be available as
```
DB-<virus_name>.mfa
Composition-<virus_name>.pdf
```
and the whole FASTA database as
```
VDB.mfa
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



