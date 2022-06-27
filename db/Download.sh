#!/bin/bash
#
declare -a VIRUSES=("B19V" "BufaV" "HBV" "HHV7" "HPV16" "HPV31" "HPV51" "HPV59" "HPV77" "HPyV6" "HSV-1" "KI" "NJPyV" "TTV" "BKpV" "CutaV" "HCMV" "HHV8" "HPV18" "HPV39" "HPV56" "HPV68" "HPyV10" "HPyV7" "HSV-2" "LIPyV" "STLPyV" "VZV" "BocaV" "EBV" "HHV6" "HPV11" "HPV2" "HPV45" "HPV58" "HPV6" "HPyV12" "HPyV9" "JCV" "MCPyV" "TSPyV" "WUHPyV");
#
function BUILD_FASTA {
  rm -f DB-$1.mfa
  mapfile -t VIDS < $2
  for VID in "${VIDS[@]}" #
    do
    ID=`echo $VID | awk '{ print $1 }'`;
    echo "==== Download $ID ...";
    echo "Download $ID ..." 1>> report-$1.txt
    efetch -db nucleotide -format fasta -id "$ID" >> DB-$1.mfa 2>> report-$1.txt
    done
  }
#
CHECK_INPUT () {
  FILE=$1
  if [ -f "$FILE" ];
    then
    echo "Input filename: $FILE"
    else
    echo -e "\e[31mERROR: input file not found ($FILE)!\e[0m";
    exit;
    fi
  }
#

#
IDX=0;
rm -f final-$VNAME.txt;
for VIRUS in "${VIRUSES[@]}"
  do
  #
  VNAME="$VIRUS";
  rm -f report-$VNAME.txt
  echo "==== RUNNING $VNAME ====";
  #
  CHECK_INPUT "$VNAME.txt";
  #
  if [[ "$VNAME" == "B19V" ]]; 
    then
    awk 'NR>2 {print t} {t=$0}' $VNAME.txt | grep "Complete genome" | awk '{ print $2 }' | grep -v "-" | tr -cd '\n[:alnum:]_.-' > ID-$VNAME.ids;
    else
    awk 'NR>2 {print t} {t=$0}' $VNAME.txt | grep "Complete genome" | awk '{ print $1 }' | grep -v "-" | tr -cd '\n[:alnum:]_.-' > ID-$VNAME.ids;
    fi
  BUILD_FASTA "$VNAME" "ID-$VNAME.ids";
  ((++IDX));
  if [[ "$IDX" == "20" ]];
    then
    sleep 2;
    IDX=0;
    fi
  #
  done
#


