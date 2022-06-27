#!/bin/bash
#
# NO HPV77!
declare -a VIRUSES=("B19V" "BufaV" "HBV" "HHV7" "HPV16" "HPV31" "HPV51" "HPV59" "HPyV6" "HSV-1" "KI" "NJPyV" "TTV" "BKpV" "CutaV" "HCMV" "HHV8" "HPV18" "HPV39" "HPV56" "HPV68" "HPyV10" "HPyV7" "HSV-2" "LIPyV" "STLPyV" "VZV" "BocaV" "EBV" "HHV6" "HPV11" "HPV2" "HPV45" "HPV58" "HPV6" "HPyV12" "HPyV9" "JCV" "MCPyV" "TSPyV" "WUHPyV");
#
rm -f VDB.mfa;
#
for VIRUS in "${VIRUSES[@]}"
  do
  #
  echo "Creating $VIRUS ...";
  gto_fasta_rand_extra_chars < FIL-DB-$VIRUS.mfa >> VDB.mfa 
  #
  done
#
