#!/usr/bin/env bash
echo IMPORTER SCRIPT STARTING
if [ "$1" == '' ]; then
  echo -n "Enter DB password: "
  read -s dbpass
else
  dbpass=$1
fi
mysql -u root -h localhost -p$dbpass <<EOF
USE Quizzing
SET FOREIGN_KEY_CHECKS=0;
source ./mock_data/Users.sql;
source ./mock_data/QuizOwners.sql;
source ./mock_data/Questions.sql;
source ./mock_data/QuizToUser.sql;
source ./mock_data/Notifications.sql;
source ./mock_data/QuizAttached.sql;
source ./mock_data/AnswerHistory.sql;
source ./mock_data/UserMessageHistory.sql;
commit;
SET FOREIGN_KEY_CHECKS=1;
EOF
echo IMPORTER SCRIPT FINISHED
exit 0