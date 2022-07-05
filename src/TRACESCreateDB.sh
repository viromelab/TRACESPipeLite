#!/bin/bash
#
declare -a VIRUSES=("B19V" "BuV" "CuV" "HBoV" "AAV" "BKPyV" "JCPyV" "KIPyV"
                    "WUPyV" "MCPyV" "HPyV6" "HPyV7" "TSPyV" "HPyV9" "MWPyV"
                    "STLPyV" "HPyV12" "NJPyV" "LIPyV" "SV40" "TTV"
                    "HAV" "HBV" "HCV" "HDV" "HEV" "SENV" "HPV2" "HPV6" "HPV11"
                    "HPV16" "HPV18" "HPV31" "HPV39" "HPV45" "HPV51" "HPV56"
                    "HPV58" "HPV59" "HPV68" "HPV77" "HSV-1" "HSV-2" "VZV"
                    "EBV" "HCMV" "HHV6" "HHV7" "KSHV" "ReDoV" "VARV" "MPXV"
                    "EV" "SARS2" "HERV" "MT");
#
# ==============================================================================
#
function BUILD_FASTA {
  rm -f DB-$1.mfa
  mapfile -t VIDS < $2
  for VID in "${VIDS[@]}" #
    do
    ID=`echo $VID | awk '{ print $1 }'`;
    echo "==== Download $ID ...";
    echo "Download $ID ..." 1>> report-$1.txt
    efetch -db nucleotide -format fasta -id "$ID" >> ../DB-$1.mfa 2>> report-$1.txt
    done
  }
#
# ==============================================================================
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
# ==============================================================================
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
  CHECK_INPUT "IDS/ID-$VNAME.ids";
  BUILD_FASTA "$VNAME" "IDS/ID-$VNAME.ids";
  ((++IDX));
  if [[ "$IDX" == "20" ]];
    then
    sleep 2;
    IDX=0;
    fi
  #
  done
#
# ==============================================================================
#
