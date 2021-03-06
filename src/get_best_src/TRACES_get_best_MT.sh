#!/bin/bash
#
RESULT=`cat top-metagenomics.csv \
| grep -a -e "NC_012920.1" -e "NC012920.1" \
| awk '{ if($3 > 0 && $2 > 10000 && $2 < 20000) print $3"\t"$4; }' \
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

