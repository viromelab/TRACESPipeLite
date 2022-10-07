#
CHECK_INPUT () {
  FILE=$1
  if [ -f "$FILE" ];
    then
    echo "Input filename: $FILE"
    else
    echo -e "\e[31mERROR: input file not found ($FILE)!\e[0m";
    SHOW_MENU;
    exit;
    fi
  }
#
INPUT_FILE="latest_list.txt"
CHECK_INPUT "$INPUT_FILE";
#
mapfile -t INT_DATA < $INPUT_FILE;
for dint in "${INT_DATA[@]}"
  do
  #
  NAME1=`echo $dint | awk -F ':' '{ print $1 }'`;
  NAME2=`echo $dint | awk -F ':' '{ print $2 }'`;
  OUT=`echo $dint | awk -F ':' '{ print $3 }'`;
  GID=`echo $dint | awk -F ':' '{ print $4 }'`;
  #
  CHECK_INPUT "$NAME1";
  CHECK_INPUT "$NAME2";
  #
  echo "NAME1: $NAME1";
  echo "NAME2: $NAME2";
  echo "OUT  : $OUT";
  echo "GID  : $GID";
  #
  efetch -db nucleotide -id $GID -format fasta > $GID.fa
  CHECK_INPUT "$GID.fa";
  ./TRACESPipeLite.sh --specific $GID.fa --only-specific -t 8 -o $OUT --reads1 $NAME1 --reads2 $NAME2
  #
  done
