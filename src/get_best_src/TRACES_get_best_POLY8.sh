#!/bin/bash
#
RESULT=`cat top-metagenomics.csv \
| grep -a -e "Polyomavirus_8" -e "polyomavirus_8" -e "Polyoma_8" -e "polyoma_8" -e "Polyomavirus 8" -e "polyomavirus 8" -e "Polyoma 8" -e "polyoma 8" -e "TSPyV" -e "NC_014361" \
| grep -a -e "complete genome" -e "complete_genome" \
| awk '{ if($3 > 0 && $2 > 3000 && $2 < 7000) print $3"\t"$4; }' \
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

