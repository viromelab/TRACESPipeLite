#!/bin/bash
#
RESULT=`cat top-metagenomics.csv \
| grep -a -e "erpesvirus_3" -e "erpesvirus 3" -e " HHV-3" -e " HHV3" \
| grep -a -e "Human" -e "human" -e "omo sapiens" -e "omo_sapiens" \
| grep -a -e "omplete genome" -e "omplete_genome" \
| awk '{ if($3 > 0 && $2 > 100000 && $2 < 220000) print $3"\t"$4; }' \
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

