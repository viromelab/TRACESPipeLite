# TRACESPipeLite

Lite version of TRACESPipe [viral metagenomics only]

## 1. Installation ##

```
git clone https://github.com/viromelab/TRACESPipeLite.git
cd TRACESPipeLite/src/
lzma -d VDB.fa.lzma
chmod +x *.sh
./TRACESPipeLite.sh --install
```

## 2. Running example ##

```
./TRACESPipeLite.sh --reads1 test-fw.fq.gz --reads2 test-rv.fq.gz \
--database VDB.fasta --output test_viral_analysis --threads 8
```

## 3. Usage ##

```
./TRACESPipeLite.sh -h
```

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
                                                          
 -t  <INT>, --threads <INT>     Number of threads,        
 -o  <STR>, --output <STR>      Output folder name,       
                                                          
 -r1 <STR>, --reads1 <STR>      FASTQ reads (forward),    
 -r2 <STR>, --reads2 <STR>      FASTQ reads (reverse),    
                                                          
 -db <STR>, --database <STR>    FASTA Viral Database.     
                                                          
 Example -----------------------------------------------  
                                                          
 TRACESPipeLite.sh --reads1 reads_forward.fq.gz \        
   --reads2 reads_reverse.fq.gz --database VDB.fasta \   
   --output lite_viral_analysis --threads 8               
                                                          
 -------------------------------------------------------  
```

## 4. Citation ##

Please cite:
```
Pratas, D., Toppinen, M., Pyöriä, L., Hedman, K., Sajantila, A. and Perdomo, M.F., 2020. 
A hybrid pipeline for reconstruction and analysis of viral genomes at multi-organ level.
GigaScience, 9(8), p.giaa086.
```
[PDF Link](https://doi.org/10.1093/gigascience/giaa086)

## 5. License ##

GPL v3.

For more information see LICENSE file or visit
<pre>http://www.gnu.org/licenses/gpl-3.0.html</pre>



