#!/bin/bash
#
declare -a VIRUSES=("B19V" "BufaV" "HBV" "HHV7" "HPV16" "HPV31" "HPV51" "HPV59" "HPV77" "HPyV6" "HSV-1" "KI" "NJPyV" "TTV" "BKpV" "CutaV" "HCMV" "HHV8" "HPV18" "HPV39" "HPV56" "HPV68" "HPyV10" "HPyV7" "HSV-2" "LIPyV" "STLPyV" "VZV" "BocaV" "EBV" "HHV6" "HPV11" "HPV2" "HPV45" "HPV58" "HPV6" "HPyV12" "HPyV9" "JCV" "MCPyV" "TSPyV" "WUHPyV");
#
rm -f final-$VNAME.txt;
#
for VIRUS in "${VIRUSES[@]}"
  do
  #
  VNAME="$VIRUS";
  echo "==== RUNNING $VNAME "; 
  #
  rm -f *out*.fasta;
  gto_fasta_extract_read_by_pattern -p "omplete" < DB-$VNAME.mfa > FIL-DB-$VNAME.mfa
  gto_fasta_split_reads < FIL-DB-$VNAME.mfa 2> tmp.tp;
  N_VIRUSES=`grep ".fasta" tmp.tp | wc -l | awk '{ print $1;}'`;
  rm -f tmp.tp;
  #
  rm -f final-$VNAME.txt;
  for((x=1 ; x<=$N_VIRUSES ; ++x));
    do 
    gto_fasta_to_seq < out$x.fasta | gto_info > info-$x.txt 2> err.txt;
    I_TOTAL=`grep "Number of symbols" info-$x.txt | awk '{ print $5;}'`;
    I_A=`grep "^A  " info-$x.txt | awk '{ print $3;}'`;
    I_C=`grep "^C  " info-$x.txt | awk '{ print $3;}'`;
    I_G=`grep "^G  " info-$x.txt | awk '{ print $3;}'`;
    I_T=`grep "^T  " info-$x.txt | awk '{ print $3;}'`;
    I_OTHERS=`echo "$I_TOTAL - ($I_A+$I_C+$I_G+$I_T)" | bc -l`
    I_GC=`echo "$I_G + $I_C" | bc -l`
    printf "%u\t%u\t%u\t%u\n" "$x" "$I_TOTAL" "$I_GC" "$I_OTHERS" >> final-$VNAME.txt;
    done
  #
  # MAKE PLOT HERE:
gnuplot << EOF
    reset
    set terminal pdfcairo enhanced color font 'Verdade,9'
    set output "Composition-$VNAME.pdf"
    set style line 101 lc rgb '#000000' lt 1 lw 4
    set border 3 front ls 101
    set tics nomirror out scale 0.5
    set format '%g'
    set size ratio 0.22
    set key out horiz center top
    set yrange [:]
    set xrange [:]
    set xtics auto
    set ytics auto
    #set ytics 0.04
    unset grid
    set ylabel "Symbols"
    set xlabel "Genome"
    set border linewidth 1.5
    set style line 1 lc rgb '#322152' lt 1 lw 2 pt 5 ps 0.4 # --- blue
    set style line 2 lc rgb '#CC0000' lt 1 lw 2 pt 7 ps 0.4 # --- red
    set style line 3 lc rgb '#009900' lt 1 lw 2 pt 6 ps 0.4 # --- green
    set xtics auto
    plot "final-$VNAME.txt" using 1:2 title "Total nucleotides" with lines ls 1, "final-$VNAME.txt" using 1:3 title "GC nucleotides" with lines ls 2, "final-$VNAME.txt" using 1:4 title "non-nucleotides" with lines ls 3
EOF
  #
  done
#
rm -f out*.fasta
#


