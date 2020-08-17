#!/usr/bin/env bash
echo DROPER SCRIPT STARTING
if [ "$1" == '' ]; then
  echo -n "Enter DB password: "
  read -s dbpass
else
  dbpass=$1
fi
mysql -u root -h localhost -p$dbpass <<EOF
USE Quizzing
SET FOREIGN_KEY_CHECKS = 0;
truncate table AnswerHistory;
truncate table Notifications;
truncate table Questions;
truncate table QuizAttached;
truncate table QuizOwners;
truncate table QuizToUser;
truncate table UserMessageHistory;
truncate table Users;
SET FOREIGN_KEY_CHECKS = 1;
EOF
echo DROPER SCRIPT FINISHED
exit 0