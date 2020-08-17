#!/usr/bin/env bash
echo chose option:
echo "1. import in parallel"
echo "2. truncate + import in parallel"
echo "3. check data"
echo -n "choice: "
read usrchoice
dbpass=$MYSQL_ROOT_PASSWORD

#function get_pass() {
#  if [ "$1" == '' ]; then
#    echo -n "Enter DB password: "
#    read -s dbpass
#  else
#    dbpass=$1
#  fi
#}

function checker() {
  bash ./checker.sh "$dbpass"
}

function elapsed(){
duration=$SECONDS
echo IMPORTER SCRIPT FINISHED
echo "time elapsed: $duration"
}

SECONDS=0
if [ "$usrchoice" == '1' ]; then
  get_pass
  checker
  bash ./importer_2.sh "$dbpass"
  checker
  elapsed
  exit 0
elif [ "$usrchoice" == '2' ]; then
  get_pass
  checker
  bash ./droper.sh "$dbpass"
  bash ./importer_2.sh "$dbpass"
  checker
  elapsed
  exit 0
elif [ "$usrchoice" == '3' ]; then
  get_pass
  checker
  elapsed
  exit 0

else
  echo WRONG OPTION FINISHING SCRIPT
  exit 1
fi
