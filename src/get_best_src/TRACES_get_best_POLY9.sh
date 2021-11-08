#!/bin/bash
#
RESULT=`cat top-metagenomics.csv \
| grep -a -e "Polyomavirus_9" -e "polyomavirus_9" -e "Polyoma_9" -e "polyoma_9" -e "Polyomavirus 9" -e "polyomavirus 9" -e "Polyoma 9" -e "polyoma 9" -e "HPyV9" -e "NC_015150" \
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

