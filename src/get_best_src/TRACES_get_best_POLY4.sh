#!/bin/bash
#
RESULT=`cat top-metagenomics.csv \
| grep -a -e "olyomavirus_4 " -e "olyomavirus_4|" -e "olyomavirus 4 " -e "olyomavirus 4|"  -e "WU_polyomavirus" -e "WU polyomavirus" -e "WU_virus" -e "WU virus" -e "WUPyV" -e "NC_009539" -e "NC009539" \
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

