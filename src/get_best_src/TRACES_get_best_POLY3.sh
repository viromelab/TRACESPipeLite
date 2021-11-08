#!/bin/bash
#
RESULT=`cat top-metagenomics.csv \
| grep -a -e "olyomavirus_3 " -e "olyomavirus_3|" -e "olyomavirus 3" -e "olyomavirus 3|" -e "KI_polyomavirus" -e "KI polyomavirus" -e "KI_virus" -e "KI virus" -e "KIPyV" -e "NC_009238" \
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

