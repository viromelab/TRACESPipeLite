#!/bin/bash
#
RESULT=`cat top-metagenomics.csv \
| grep -a -e "MW_polyomavirus" -e "MW_virus" -e "MWPyV" -e "olyomavirus_10" -e "MW polyomavirus" -e "MW virus" -e "MWPyV" -e "olyomavirus 10" -e "MW polyomavirus" -e "NC_018102" -e "NC018102" \
| grep -a -e "complete genome" -e "complete_genome" \
| awk '{ if($3 > 0 && $2 > 2500 && $2 < 7000) print $3"\t"$4; }' \
| head -n 1 \
| awk '{ print $1"\t"$2;}' \
| sed "s/NC\_/NC-/" \
| tr '_' '\t' \
| awk '{ print $1"\t"$2;}'`;
if [ -z "$RESULT" ]
  then
  echo -e "-\t-";
  else
  echo "$RESULT" | sed "s/NC-/NC\_/"
  fi

