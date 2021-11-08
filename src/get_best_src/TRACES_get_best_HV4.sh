#!/bin/bash
#
RESULT=`cat top-metagenomics.csv \
| grep -a -e "Epstein" -e "epstein" -e "erpesvirus_4" -e "erpesvirus 4" \
| grep -a -e "human" -e "Human" -e "omo sapiens" -e "omo_sapiens" \
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

