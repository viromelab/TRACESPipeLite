#!/bin/bash
#
STUDY="data";
RUN="0";
INSTALL="0";
THREADS="8";
PLOTS="0";
READS1="";
READS2="";
FILTER_HUMAN="0";
HUMAN_FASTA="chm13v2.0.fa.gz";
DATABASE="VDB.mfa";
OUTPUT="out_analysis";
MIN_LEN="20";
BWA_N="0.02";
MIN_SIMILARITY="3.0";
MAX_COVERAGE_PROFILE=0;
COVERAGE_MIN_X="0";
COVERAGE_MAX="1000";
COVERAGE_LOG_SCALE="";
COVERAGE_WINDOW_SIZE="5";
COVERAGE_DROP="1";
SPECIFIC="";
SPECIFIC_ON="0";
SPECIFIC_ONLY="0";
#
################################################################################
#
SHOW_MENU () {
  echo " -------------------------------------------------------- ";
  echo "                                                          ";
  echo " TRACESPipeLite.sh : TRACESPipe lite version v2.2         ";
  echo "                                                          ";
  echo " This is a lite version of TRACESPipe. It provides        ";
  echo " automatic reconstruction (reference-based only) of       ";
  echo " viral genomes and performs basic analyses.               ";
  echo "                                                          ";
  echo " Program options ---------------------------------------- ";
  echo "                                                          ";
  echo " -h, --help                      Show this,               ";
  echo " -i, --install                   Installation (w/ conda), ";
  echo "                                                          ";
  echo " -np,       --no-plots           NO coverage plots,       ";
  echo " -lg <INT>, --log-scale <INT>    Coverage log scale,      ";
  echo " -ws <INT>, --window <INT>       Coverage window size,    ";
  echo " -dr <INT>, --drop <INT>         Coverage drop size,      ";
  echo " -cx <INT>, --start <INT>        Coverage start x-axis,   ";
  echo " -ma <INT>, --maximum <INT>      Coverage maximum (crop), ";
  echo " -si <INT>, --similarity <DBL>   Minimum similarity for   ";
  echo "                                 applying reconstruction, ";
  echo " -s  <STR>, --specific <STR>     Use specific sequence,   ";
  echo " -os,       --only-specific      Run only specific,       ";
  echo "                                                          ";
  echo " -fh,       --filter-human       Filter human DNA,        ";
  echo "                                                          ";
  echo " -t  <INT>, --threads <INT>      Number of threads,       ";
  echo " -o  <STR>, --output <STR>       Output folder name,      ";
  echo "                                                          ";
  echo " -r1 <STR>, --reads1 <STR>       FASTQ reads (forward),   ";
  echo " -r2 <STR>, --reads2 <STR>       FASTQ reads (reverse),   ";
  echo "                                                          ";
  echo " -db <STR>, --database <STR>     FASTA Viral Database.    ";
  echo "                                                          ";
  echo " Example -----------------------------------------------  ";
  echo "                                                          ";
  echo " TRACESPipeLite.sh --reads1 reads_forward.fq.gz \\        ";
  echo "   --reads2 reads_reverse.fq.gz --database VDB.mfa \\     ";
  echo "   --output lite_viral_analysis --threads 8               ";
  echo "                                                          ";
  echo " -------------------------------------------------------  ";
  }
#
################################################################################
#
CHECK_INPUT () {
  FILE=$1
  if [ -f "$FILE" ];
    then
    echo "Input filename: $FILE"
    else
    echo -e "\e[31mERROR: input file not found ($FILE)!\e[0m";
    SHOW_MENU;
    exit;
    fi
  }
#
################################################################################
#
PROGRAM_EXISTS () {
  printf "Checking $1 ... ";
  if ! [ -x "$(command -v $1)" ];
    then
    echo -e "\e[41mERROR\e[49m: $1 is not installed." >&2;
    echo -e "\e[42mTIP\e[49m: Try: ./TRACESPipeLite.sh --install" >&2;
    exit 1;
    else
    echo -e "\e[42mSUCCESS!\e[49m";
    fi
  }
#
################################################################################
#
CHECK_PROGRAMS () {
  PROGRAM_EXISTS "AdapterRemoval";
  PROGRAM_EXISTS "gto_fasta_extract_read_by_pattern";
  PROGRAM_EXISTS "gto_filter";
  PROGRAM_EXISTS "FALCON";
  PROGRAM_EXISTS "bwa";
  PROGRAM_EXISTS "bowtie2";
  PROGRAM_EXISTS "samtools";
  PROGRAM_EXISTS "bcftools";
  PROGRAM_EXISTS "bedops";
  PROGRAM_EXISTS "bedtools";
  PROGRAM_EXISTS "igv";
  PROGRAM_EXISTS "tabix";
  }
#
################################################################################
#
# ==============================================================================
# THESE ARE THE CURRENT FLAGGED VIRUSES OR VIRUSES GROUPS FOR ENHANCED ASSEMBLY:
# IF THIS LIST IS AUGMENTED THEN IT REQUIRES -> TRACES_get_best_<$VIRUS>.sh
# FILE TO SEARCH FOR SPECIFIC IDs OF EACH VIRUS TYPE
#
# HERV IS CURRENTLY BEING ADDRESSED AS HAPLOID IN ALIGNMENTS -> THIS WILL
# REQUIRE ADAPTATION IN THE FUTURE.
#
declare -a VIRUSES=("B19V" "BuV" "CuV" "HBoV" "AAV" "BKPyV" "JCPyV" "KIPyV"
                    "WUPyV" "MCPyV" "HPyV6" "HPyV7" "TSPyV" "HPyV9" "MWPyV"
                    "STLPyV" "HPyV12" "NJPyV" "LIPyV" "SV40" "TTV" "TTVmid"
                    "TTVmin" "HAV" "HBV" "HCV" "HDV" "HEV" "SENV" "HPV2"
                    "HPV6" "HPV11" "HPV16" "HPV18" "HPV31" "HPV39" "HPV45"
                    "HPV51" "HPV56" "HPV58" "HPV59" "HPV68" "HPV77" "HSV-1"
                    "HSV-2" "VZV" "EBV" "HCMV" "HHV6" "HHV7" "KSHV" "ReDoV"
                    "VARV" "MPXV" "EV" "SARS2" "HERV" "MT");
#
################################################################################
#
if [[ "$#" -lt 1 ]];
  then
  HELP=1;
  fi
#
POSITIONAL=();
#
while [[ $# -gt 0 ]]
  do
  i="$1";
  case $i in
    -h|--help|?)
      HELP=1;
      shift
    ;;
    -i|-c|--install|--compile)
      INSTALL=1;
      shift
    ;;
    -np|--no-plots)
      PLOTS=1;
      shift
    ;;
    -t|--threads)
      THREADS="$2";
      shift 2;
    ;;
    -r1|-r|--input1|--reads|--reads1)
      READS1="$2";
      RUN=1;
      shift 2;
    ;;
    -r2|--input2|--reads2)
      READS2="$2";
      RUN=1;
      shift 2;
    ;;
    -db|--database)
      DATABASE="$2";
      shift 2;
    ;;
    -fh|--filter-human)
      FILTER_HUMAN="1";
      shift;
    ;;
    -lg|--log-scale)
      COVERAGE_LOG_SCALE="$2";
      SHOW_HELP=0;
      shift 2;
    ;;
    -ws|--window-size)
      COVERAGE_WINDOW_SIZE="$2";
      SHOW_HELP=0;
      shift 2;
    ;;
    -dr|--drop)
      COVERAGE_DROP="$2";
      SHOW_HELP=0;
      shift 2;
    ;;
    -cx|--start)
      COVERAGE_MIN_X="$2";
      SHOW_HELP=0;
      shift 2;
    ;;
    -ma|--maximum)
      COVERAGE_MAX="$2";
      SHOW_HELP=0;
      shift 2;
    ;;
    -si|--similarity)
      MIN_SIMILARITY="$2";
      SHOW_HELP=0;
      shift 2;
    ;;
    -o|--output)
      OUTPUT="$2";
      shift 2;
    ;;
    -s|--specific)
      SPECIFIC_ON="1";
      SPECIFIC="$2";
      shift 2;
    ;;
    -os|--only-specific)
      SPECIFIC_ONLY="1";
      shift
    ;;
    -*) # unknown option with small
    echo "Invalid arg ($1)!";
    echo "For help, try: TRACESPipeLite.sh -h"
    exit 1;
    ;;
  esac
  done
#
set -- "${POSITIONAL[@]}" # restore positional parameters
#
################################################################################
#
if [[ "$HELP" -eq "1" ]];
  then
  SHOW_MENU;
  exit;
  fi
#
################################################################################
#
if [[ "$INSTALL" -eq "1" ]];
  then
  #
  conda config --add channels conda-forge
  conda config --add channels bioconda
  conda config --add channels defaults
  #
  conda install -c bioconda AdapterRemoval -y
  conda install -c cobilab gto -y
  conda install -c cobilab falcon -y
  conda install -c bioconda bwa -y
  conda install -c bioconda bowtie2 -y
  conda install -c bioconda igv -y
  conda install -c bioconda samtools=1.9 -y
  conda install -c bioconda bcftools=1.9 -y
  conda install -c bioconda tabix -y
  conda install -c bioconda bedops -y
  conda install -c bioconda bedtools -y
  #
  CHECK_PROGRAMS
  #
  echo "Generating adapters for AdapterRemoval ...";
  echo "TACACTCTTTCCCTACACGACGCTCTTCCGATCT      AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTA" >  adapters_ar.fa;
  echo "GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT      AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC" >> adapters_ar.fa;
  echo "Done!";
  #
  echo "Building human to filter human DNA from reads ...";
  wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/analysis_set/chm13v2.0.fa.gz
  gunzip chm13v2.0.fa.gz
  bowtie2-build chm13v2.0.fa host_DB
  echo "Done!";
  #
  exit;
  #
  fi
#
################################################################################
#
  if [[ "$FILTER_HUMAN" -eq "1" ]];
    then
    #
    echo "Removing host data ...";
    #CHECK_INPUT "$HOST_FASTA";
    CHECK_INPUT $READS1
    CHECK_INPUT $READS2
    #
    bowtie2 -p $THREADS -x host_DB -1 $READS1 -2 $READS2 --un-conc-gz SAMPLE_host_removed > $STUDY-data.sam 2>> report_stderr.txt
    samtools view -bS $STUDY-data.sam > $STUDY-data.bam 2>> report_stderr.txt
    samtools view -b -f 12 -F 256 $STUDY-data.bam > $STUDY-data-no-human.bam 2>> report_stderr.txt
    samtools sort -n -o $STUDY-sorted-data.bam $STUDY-data-no-human.bam 1>> report_stdout.txt 2>> report_stderr.txt
    samtools fastq -1 $STUDY-reads-r1.fq -2 $STUDY-reads-r2.fq $STUDY-sorted-data.bam 1>> report_stdout.txt 2>> report_stderr.txt
    #
    else
    #
    echo "Uncompressing reads ...";
    zcat $READS1 > $STUDY-reads-r1.fq;
    zcat $READS2 > $STUDY-reads-r2.fq;
    #
  fi
#
# ===========================================================================
  # INFORM SIZE OF UNCOMPRESSED READS -----------------------------------------
  #
  FIL_READS_SIZE_1=`ls -lah $STUDY-reads-r1.fq | awk '{ print $5; }'`;
  FIL_READS_SIZE_2=`ls -lah $STUDY-reads-r2.fq | awk '{ print $5; }'`;
  echo "READS1: $FIL_READS_SIZE_1 - READS2: $FIL_READS_SIZE_2";
  #
#
################################################################################
#
if [[ "$SPECIFIC_ON" -eq "1" || "$RUN" -eq "1" ]]
  then
  CHECK_INPUT $STUDY-reads-r1.fq
  CHECK_INPUT adapters_ar.fa
  CHECK_PROGRAMS
  #
  rm reads-tracespipe-run-tmp.fq $OUTPUT/ -fr
  mkdir -p $OUTPUT/
  #
  ## RUN TRIMMING ==============================================================
  #
  if [[ $READS2 = *[!\ ]* ]];
    then
    AdapterRemoval --threads $THREADS \
    --file1 $STUDY-reads-r1.fq --file2 $STUDY-reads-r2.fq \
    --outputcollapsed reads-tracespipe-run-tmp.fq --trimns --trimqualities \
    --minlength $MIN_LEN --collapse --adapter-list adapters_ar.fa \
    --basename AXTRL
    else
    AdapterRemoval --threads $THREADS --file1 $STUDY-reads-r1.fq \
    --outputcollapsed reads-tracespipe-run-tmp.fq --trimns --trimqualities \
    --minlength $MIN_LEN --collapse --adapter-list adapters_ar.fa \
    --basename AXTRL
    fi
  #
  rm -f AXTRL.*;
  #
  printf "NAME\tGID\tSIZE\tSIMILARITY\tBREADTH\tDEPTH\n" > $OUTPUT/final-results.txt;
  #
  fi
#
# ------------------------------------------------------------------------------
#
if [[ "$SPECIFIC_ON" -eq "1" ]];
  then
  #
  CHECK_INPUT $SPECIFIC
  #
  echo -e "\e[34m[TRACESPipeLite]\e[32m Processing specific $SPECIFIC ...\e[0m";
  #
  mkdir -p $OUTPUT/SPECIFIC_$SPECIFIC/;
  #
  rm -f SPECIFIC.fa*
  #
  cp $SPECIFIC SPECIFIC.fa
  #
  bwa index SPECIFIC.fa
  bwa aln -t $THREADS -l 1000 -n $BWA_N SPECIFIC.fa reads-tracespipe-run-tmp.fq > SPECIFIC-READS.sai
  bwa samse SPECIFIC.fa SPECIFIC-READS.sai reads-tracespipe-run-tmp.fq > SPECIFIC-READS.sam
  samtools view -bSh SPECIFIC-READS.sam > SPECIFIC-READS.bam;
  samtools view -bh -F4 SPECIFIC-READS.bam > FIL-SPECIFIC-READS.bam;
  samtools sort -o SORT-FIL-SPECIFIC-READS.bam FIL-SPECIFIC-READS.bam;
  samtools rmdup -s SORT-FIL-SPECIFIC-READS.bam RD-SORT-FIL-SPECIFIC-READS.bam;
  samtools index -b RD-SORT-FIL-SPECIFIC-READS.bam RD-SORT-FIL-SPECIFIC-READS.bam.bai
  #
  bedtools genomecov -ibam RD-SORT-FIL-SPECIFIC-READS.bam -bga > SPECIFIC-coverage.bed
  awk '$4 < 1' SPECIFIC-coverage.bed > SPECIFIC-zero-coverage.bed
  samtools faidx SPECIFIC.fa
  samtools mpileup -Ou -f SPECIFIC.fa RD-SORT-FIL-SPECIFIC-READS.bam \
  | bcftools call --ploidy 1 -P 9.9e-1 -mv -Oz -o SPECIFIC-calls.vcf.gz
  bcftools index SPECIFIC-calls.vcf.gz
  bcftools norm -f SPECIFIC.fa SPECIFIC-calls.vcf.gz -Oz -o SPECIFIC-calls.norm.vcf.gz
  bcftools filter --IndelGap 5 SPECIFIC-calls.norm.vcf.gz -Oz -o SPECIFIC-calls.norm.flt-indels.vcf.gz
  zcat SPECIFIC-calls.norm.flt-indels.vcf.gz | vcf2bed --snvs > SPECIFIC-calls.bed
  tabix -f SPECIFIC-calls.norm.flt-indels.vcf.gz
  bcftools consensus -m SPECIFIC-zero-coverage.bed -f SPECIFIC.fa SPECIFIC-calls.norm.flt-indels.vcf.gz > SPECIFIC-consensus.fa
  tail -n +2 SPECIFIC-consensus.fa > SPECIFIC-TMP_FILE.xki
  echo ">SPECIFIC consensus (REF: $SPECIFIC) [TRACESPipeLite]" > SPECIFIC-consensus.fa
  cat SPECIFIC-TMP_FILE.xki >> SPECIFIC-consensus.fa
  rm -f SPECIFIC-TMP_FILE.xki;
  #
  cp SPECIFIC-consensus.fa $OUTPUT/SPECIFIC_$SPECIFIC/
  cp SPECIFIC-zero-coverage.bed $OUTPUT/SPECIFIC_$SPECIFIC/
  cp SPECIFIC-coverage.bed $OUTPUT/SPECIFIC_$SPECIFIC/
  cp SPECIFIC-calls.bed $OUTPUT/SPECIFIC_$SPECIFIC/
  cp SPECIFIC-calls.vcf.gz $OUTPUT/SPECIFIC_$SPECIFIC/
  #
  cp RD-SORT-FIL-SPECIFIC-READS.bam $OUTPUT/SPECIFIC_$SPECIFIC/
  cp RD-SORT-FIL-SPECIFIC-READS.bam.bai $OUTPUT/SPECIFIC_$SPECIFIC/
  cp SPECIFIC.fa $OUTPUT/SPECIFIC_$SPECIFIC/
  #
  if [[ "$PLOTS" -eq "0" ]];
    then
    COVERAGE_NAME="coverage-SPECIFIC.pdf";
    CHECK_INPUT "$OUTPUT/SPECIFIC_$SPECIFIC/SPECIFIC-coverage.bed";
    #
    TOTAL_SIZE=`tail -n 1 $OUTPUT/SPECIFIC_$SPECIFIC/SPECIFIC-coverage.bed | awk '{ print $3}'`;
    ZERO_COVERAGE=`awk '{sum += ($3-$2)} END {print sum}' $OUTPUT/SPECIFIC_$SPECIFIC/SPECIFIC-zero-coverage.bed`;
    if [ -z $ZERO_COVERAGE ]
      then
      ZERO_COVERAGE=0;
      fi
    BREADTH=`echo "scale=4; (100-(($ZERO_COVERAGE/$TOTAL_SIZE)*100))" | bc -l`;
    #
    rm -f x.projected.profile;
    ./TRACES_project_coordinates.sh $OUTPUT/SPECIFIC_$SPECIFIC/SPECIFIC-coverage.bed $COVERAGE_MAX | gto_filter -w $COVERAGE_WINDOW_SIZE -d $COVERAGE_DROP > x.projected.profile;
    DEPTH=`./TRACES_project_coordinates.sh $OUTPUT/SPECIFIC_$SPECIFIC/SPECIFIC-coverage.bed $COVERAGE_MAX | awk '{sum+=$2} END { print sum/NR}'`;
    #
    printf "SPECIFIC\t$GID\t$TOTAL_SIZE\t$SIMILARITY\t$BREADTH\t$DEPTH\n" >> $OUTPUT/final-results.txt;
    #
    if [[ "$COVERAGE_LOG_SCALE" -eq "" ]];
      then
      gnuplot << EOF
      reset
      set terminal pdfcairo enhanced color font 'Verdana,12'
      set output "$COVERAGE_NAME"
      set style line 101 lc rgb '#000000' lt 1 lw 4
      set border 3 front ls 101
      set tics nomirror out scale 0.75
      set format '%g'
      set size ratio 0.2
      set key outside horiz center top
      set yrange [$COVERAGE_MIN_X:]
      set xrange [:]
      set xtics auto
      set grid
      set ylabel "Depth"
      set xlabel "Position"
      set border linewidth 1.5
      set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 0.4 # --- blue
      set style line 2 lc rgb '#000000' lt 1 lw 2 pt 6 ps 0.4 # --- green
      set style line 3 lc rgb '#dd181f' lt 1 lw 4 pt 7 ps 0.4 # --- ?
      set style line 4 lc rgb '#4d1811' lt 1 lw 4 pt 8 ps 0.4 # --- ?
      set style line 5 lc rgb '#1d121f' lt 1 lw 4 pt 9 ps 0.4 # --- ?
      plot "x.projected.profile" using 1:2 t "Depth coverage" with lines ls 2
EOF
      else
      gnuplot << EOF
      reset
      set terminal pdfcairo enhanced color font 'Verdana,12'
      set output "$COVERAGE_NAME"
      set style line 101 lc rgb '#000000' lt 1 lw 4
      set border 3 front ls 101
      set tics nomirror out scale 0.75
      set format '%g'
      set size ratio 0.2
      set key outside horiz center top
      set yrange [$COVERAGE_MIN_X:]
      set xrange [:]
      set xtics auto
      set logscale y $COVERAGE_LOG_SCALE
      set grid
      set ylabel "Depth"
      set xlabel "Position"
      set border linewidth 1.5
      set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 0.4 # --- blue
      set style line 2 lc rgb '#000000' lt 1 lw 2 pt 6 ps 0.4 # --- green
      set style line 3 lc rgb '#dd181f' lt 1 lw 4 pt 7 ps 0.4 # --- ?
      set style line 4 lc rgb '#4d1811' lt 1 lw 4 pt 8 ps 0.4 # --- ?
      set style line 5 lc rgb '#1d121f' lt 1 lw 4 pt 9 ps 0.4 # --- ?
      plot "x.projected.profile" using 1:2 t "Depth coverage" with lines ls 2
EOF
      fi
    #
    cp coverage-SPECIFIC.pdf $OUTPUT/SPECIFIC_$SPECIFIC/
    rm -f coverage-SPECIFIC.pdf x.projected.profile;
  fi
  #
  rm -f SPECIFIC-consensus.fa SPECIFIC-zero-coverage.bed SPECIFIC-coverage.bed \
  SPECIFIC-calls.bed SPECIFIC-calls.vcf.gz SPECIFIC-calls.norm.flt-indels.vcf.gz \
  SPECIFIC-calls.norm.flt-indels.vcf.gz.tbi SPECIFIC-calls.norm.vcf.gz \
  SPECIFIC-calls.vcf.gz.csi;
  #
  rm -f SPECIFIC-READS.sai SPECIFIC-READS.sam SPECIFIC-READS.bam \
  FIL-SPECIFIC-READS.bam SORT-FIL-SPECIFIC-READS.bam \
  SORT-FIL-SPECIFIC-READS.bam.bai SPECIFIC.fa RD-SORT-FIL-SPECIFIC-READS.bam \
  RD-SORT-FIL-SPECIFIC-READS.bam.bai SPECIFIC.fa.amb SPECIFIC.fa.ann \
  SPECIFIC.fa.bwt SPECIFIC.fa.fai SPECIFIC.fa.pac SPECIFIC.fa.sa;
  #
fi
#
################################################################################
#
if [[ "$SPECIFIC_ONLY" -eq "1" ]];
  then
  RUN="0";
  fi
#
################################################################################
#
if [[ "$RUN" -eq "1" ]];
  then
  #
  CHECK_INPUT $DATABASE
  #
  ## RUN VIRAL METAGENOMIC COMPOSITION =========================================
  #
  FALCON -v -n $THREADS -t 10000 -F -m 6:1:1:0/0 -m 13:50:1:0/0 -m 19:500:1:5/10 -g 0.85 -c 10 -x top-metagenomics.csv reads-tracespipe-run-tmp.fq $DATABASE
  cp top-metagenomics.csv $OUTPUT/
  #
  ## GET HIGHEST SIMILAR REFERENCE =============================================
  #
  rm -f best-viral-metagenomics.txt
  for VIRUS in "${VIRUSES[@]}"
    do
    printf "%s\t" "$VIRUS" >> best-viral-metagenomics.txt;
    #
    RESULT=`cat top-metagenomics.csv | grep -a -f IDS/ID-$VIRUS.ids \
    | awk '{ if($3 > 0 && $2 > 200 && $2 < 9000000) print $3"\t"$4; }' \
    | head -n 1 \
    | awk '{ print $1"\t"$2;}' \
    | sed "s/NC\_/NC-/" \
    | tr '_' '\t' \
    | awk '{ print $1"\t"$2;}'`;
    if [ -z "$RESULT" ]
      then
      echo -e "-\t-" >> best-viral-metagenomics.txt
      else
      echo "$RESULT" | sed "s/NC-/NC\_/" >> best-viral-metagenomics.txt
      fi
    #
    done
  cp best-viral-metagenomics.txt $OUTPUT/
  #
  ## ALIGN READS TO EACH HIGHEST SIMILAR REFERENCE =============================
  #
  mapfile -t BEST_V_DATA < best-viral-metagenomics.txt;
  for vline in "${BEST_V_DATA[@]}"
    do
    #
    V_NAME=`echo $vline | awk -F '\t| ' '{ print $1 }'`;
    SIMILARITY=`echo $vline | awk -F '\t| ' '{ print $2 }'`;
    GID=`echo $vline | awk -F '\t| ' '{ print $3 }'`;
    #
    echo -e "\e[34m[TRACESPipeLite]\e[32m Processing $V_NAME ...\e[0m";
    #
    echo "ORGANISM: $V_NAME";
    echo "SIMILARITY: $SIMILARITY"
    if [[ "$SIMILARITY" != "-" ]]; then
      if (( $(bc <<<"$SIMILARITY > $MIN_SIMILARITY") )); then 
      #
      echo -e "\e[34m[TRACESPipeLite]\e[32m Minimum similarity reach in $V_NAME ...\e[0m";
      #
      mkdir -p $OUTPUT/$V_NAME/;
      #
      gto_fasta_extract_read_by_pattern -p "$GID" < $DATABASE | awk '/^>/{if(N)exit;++N;} {print;}' > $V_NAME.fa;
      #
      bwa index $V_NAME.fa
      bwa aln -t $THREADS -l 1000 -n $BWA_N $V_NAME.fa reads-tracespipe-run-tmp.fq > $V_NAME-READS.sai
      bwa samse $V_NAME.fa $V_NAME-READS.sai reads-tracespipe-run-tmp.fq > $V_NAME-READS.sam
      samtools view -bSh $V_NAME-READS.sam > $V_NAME-READS.bam;
      samtools view -bh -F4 $V_NAME-READS.bam > FIL-$V_NAME-READS.bam;
      samtools sort -o SORT-FIL-$V_NAME-READS.bam FIL-$V_NAME-READS.bam;
      samtools rmdup -s SORT-FIL-$V_NAME-READS.bam RD-SORT-FIL-$V_NAME-READS.bam;
      samtools index -b RD-SORT-FIL-$V_NAME-READS.bam RD-SORT-FIL-$V_NAME-READS.bam.bai
      #
      bedtools genomecov -ibam RD-SORT-FIL-$V_NAME-READS.bam -bga > $V_NAME-coverage.bed
      awk '$4 < 1' $V_NAME-coverage.bed > $V_NAME-zero-coverage.bed
      samtools faidx $V_NAME.fa
      samtools mpileup -Ou -f $V_NAME.fa RD-SORT-FIL-$V_NAME-READS.bam \
      | bcftools call --ploidy 1 -P 9.9e-1 -mv -Oz -o $V_NAME-calls.vcf.gz
      bcftools index $V_NAME-calls.vcf.gz
      bcftools norm -f $V_NAME.fa $V_NAME-calls.vcf.gz -Oz -o $V_NAME-calls.norm.vcf.gz
      bcftools filter --IndelGap 5 $V_NAME-calls.norm.vcf.gz -Oz -o $V_NAME-calls.norm.flt-indels.vcf.gz
      zcat $V_NAME-calls.norm.flt-indels.vcf.gz | vcf2bed --snvs > $V_NAME-calls.bed
      tabix -f $V_NAME-calls.norm.flt-indels.vcf.gz
      bcftools consensus -m $V_NAME-zero-coverage.bed -f $V_NAME.fa $V_NAME-calls.norm.flt-indels.vcf.gz > $V_NAME-consensus.fa
      tail -n +2 $V_NAME-consensus.fa > $V_NAME-TMP_FILE.xki
      echo ">$V_NAME consensus (REF: $GID) [TRACESPipeLite]" > $V_NAME-consensus.fa
      cat $V_NAME-TMP_FILE.xki >> $V_NAME-consensus.fa
      rm -f $V_NAME-TMP_FILE.xki;
      #
      cp $V_NAME-consensus.fa $OUTPUT/$V_NAME/
      cp $V_NAME-zero-coverage.bed $OUTPUT/$V_NAME/
      cp $V_NAME-coverage.bed $OUTPUT/$V_NAME/
      cp $V_NAME-calls.bed $OUTPUT/$V_NAME/
      cp $V_NAME-calls.vcf.gz $OUTPUT/$V_NAME/
      #
      cp RD-SORT-FIL-$V_NAME-READS.bam $OUTPUT/$V_NAME/
      cp RD-SORT-FIL-$V_NAME-READS.bam.bai $OUTPUT/$V_NAME/
      cp $V_NAME.fa $OUTPUT/$V_NAME/
      #
      if [[ "$PLOTS" -eq "0" ]];
        then
        COVERAGE_NAME="coverage-$V_NAME.pdf";
        CHECK_INPUT "$OUTPUT/$V_NAME/$V_NAME-coverage.bed";
        #
        TOTAL_SIZE=`tail -n 1 $OUTPUT/$V_NAME/$V_NAME-coverage.bed | awk '{ print $3}'`;
        ZERO_COVERAGE=`awk '{sum += ($3-$2)} END {print sum}' $OUTPUT/$V_NAME/$V_NAME-zero-coverage.bed`;
        if [ -z $ZERO_COVERAGE ]
          then
          ZERO_COVERAGE=0;
        fi
        BREADTH=`echo "scale=4; (100-(($ZERO_COVERAGE/$TOTAL_SIZE)*100))" | bc -l`;
        #
        rm -f x.projected.profile;
        ./TRACES_project_coordinates.sh $OUTPUT/$V_NAME/$V_NAME-coverage.bed $COVERAGE_MAX | gto_filter -w $COVERAGE_WINDOW_SIZE -d $COVERAGE_DROP > x.projected.profile;
        DEPTH=`./TRACES_project_coordinates.sh $OUTPUT/$V_NAME/$V_NAME-coverage.bed $COVERAGE_MAX | awk '{sum+=$2} END { print sum/NR}'`;
        #
        printf "$V_NAME\t$GID\t$TOTAL_SIZE\t$SIMILARITY\t$BREADTH\t$DEPTH\n" >> $OUTPUT/final-results.txt;
        #
        if [[ "$COVERAGE_LOG_SCALE" -eq "" ]];
          then
          gnuplot << EOF
          reset
          set terminal pdfcairo enhanced color font 'Verdana,12'
          set output "$COVERAGE_NAME"
          set style line 101 lc rgb '#000000' lt 1 lw 4
          set border 3 front ls 101
          set tics nomirror out scale 0.75
          set format x '%.0s%c'
          set size ratio 0.2
          set key outside horiz center top
          set yrange [$COVERAGE_MIN_X:]
          set xrange [:]
          set xtics auto
          set grid
          set ylabel "Depth"
          set xlabel "Position"
          set border linewidth 1.5
          set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 0.4 # --- blue
          set style line 2 lc rgb '#000000' lt 1 lw 2 pt 6 ps 0.4 # --- green
          set style line 3 lc rgb '#dd181f' lt 1 lw 4 pt 7 ps 0.4 # --- ?
          set style line 4 lc rgb '#4d1811' lt 1 lw 4 pt 8 ps 0.4 # --- ?
          set style line 5 lc rgb '#1d121f' lt 1 lw 4 pt 9 ps 0.4 # --- ?
          plot "x.projected.profile" using 1:2 t "Depth coverage" with lines ls 2
EOF
        else
          gnuplot << EOF
          reset
          set terminal pdfcairo enhanced color font 'Verdana,12'
          set output "$COVERAGE_NAME"
          set style line 101 lc rgb '#000000' lt 1 lw 4
          set border 3 front ls 101
          set tics nomirror out scale 0.75
          set format x '%.0s%c'
          set size ratio 0.2
          set key outside horiz center top
          set yrange [$COVERAGE_MIN_X:]
          set xrange [:]
          set xtics auto
          set logscale y $COVERAGE_LOG_SCALE
          set grid
          set ylabel "Depth"
          set xlabel "Position"
          set border linewidth 1.5
          set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 ps 0.4 # --- blue
          set style line 2 lc rgb '#000000' lt 1 lw 2 pt 6 ps 0.4 # --- green
          set style line 3 lc rgb '#dd181f' lt 1 lw 4 pt 7 ps 0.4 # --- ?
          set style line 4 lc rgb '#4d1811' lt 1 lw 4 pt 8 ps 0.4 # --- ?
          set style line 5 lc rgb '#1d121f' lt 1 lw 4 pt 9 ps 0.4 # --- ?
          plot "x.projected.profile" using 1:2 t "Depth coverage" with lines ls 2
EOF
        fi
        cp coverage-$V_NAME.pdf $OUTPUT/$V_NAME/
        rm -f coverage-$V_NAME.pdf x.projected.profile;
        #
      fi
      rm -f $V_NAME-consensus.fa $V_NAME-zero-coverage.bed $V_NAME-coverage.bed \
      $V_NAME-calls.bed $V_NAME-calls.vcf.gz $V_NAME-calls.norm.flt-indels.vcf.gz \
      $V_NAME-calls.norm.flt-indels.vcf.gz.tbi $V_NAME-calls.norm.vcf.gz \
      $V_NAME-calls.vcf.gz.csi;
      #
      rm -f $V_NAME-READS.sai $V_NAME-READS.sam $V_NAME-READS.bam \
      FIL-$V_NAME-READS.bam SORT-FIL-$V_NAME-READS.bam \
      SORT-FIL-$V_NAME-READS.bam.bai $V_NAME.fa RD-SORT-FIL-$V_NAME-READS.bam \
      RD-SORT-FIL-$V_NAME-READS.bam.bai $V_NAME.fa.amb $V_NAME.fa.ann \
      $V_NAME.fa.bwt $V_NAME.fa.fai $V_NAME.fa.pac $V_NAME.fa.sa;
      #
      fi
    fi
    done
  #
  rm -f reads-tracespipe-run-tmp.fq;
  rm -f top-metagenomics.csv best-viral-metagenomics.txt;
  #
  fi
#
################################################################################
#
