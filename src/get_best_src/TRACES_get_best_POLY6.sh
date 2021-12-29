#!/bin/bash
#
RESULT=`cat top-metagenomics.csv \
| grep -a -e "Polyomavirus_6" -e "Polyomavirus 6" -e "polyomavirus_6" -e "polyomavirus 6" -e "Polyoma_6" -e "Polyoma 6" -e "polyoma_6" -e "polyoma 6" -e "HPyV6" -e "NC_014406" -e "NC014406" \
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

