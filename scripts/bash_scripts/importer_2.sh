#!/usr/bin/env bash
echo IMPORTER SCRIPT STARTING
if [ "$1" == '' ]; then
  echo -n "Enter DB password: "
  read -s dbpass
else
  dbpass=$1
fi
for file in "./mock_data"/*
do
  echo import from $file STARTED
  bash ./import_part.sh $dbpass $file &
done
wait
exit 0