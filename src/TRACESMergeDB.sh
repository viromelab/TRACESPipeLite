#!/bin/bash
#
# NO HPV77!
declare -a VIRUSES=("B19V" "BuV" "CuV" "HBoV" "AAV" "BKPyV" "JCPyV" "KIPyV"
                    "WUPyV" "MCPyV" "HPyV6" "HPyV7" "TSPyV" "HPyV9" "MWPyV"
                    "STLPyV" "HPyV12" "NJPyV" "LIPyV" "SV40" "TTV"
                    "HAV" "HBV" "HCV" "HDV" "HEV" "SENV" "HPV2" "HPV6" "HPV11"
                    "HPV16" "HPV18" "HPV31" "HPV39" "HPV45" "HPV51" "HPV56"
                    "HPV58" "HPV59" "HPV68" "HPV77" "HSV-1" "HSV-2" "VZV"
                    "EBV" "HCMV" "HHV6" "HHV7" "KSHV" "ReDoV" "VARV" "MPXV"
                    "EV" "SARS2" "HERV" "MT");
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
