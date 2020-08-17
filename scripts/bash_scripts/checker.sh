#!/usr/bin/env bash
if [ "$1" == '' ]; then
  echo -n "Enter DB password: "
  read -s dbpass
else
  dbpass=$1
fi
mysql -u root -h localhost -p$dbpass <<EOF
USE Quizzing
select count(*) as 'AnswerHistory' from AnswerHistory;
select count(*)  as 'Notifications' from Notifications;
select count(*)  as 'Questions' from Questions;
select count(*)  as 'QuizAttached' from QuizAttached;
select count(*)  as 'QuizOwners' from QuizOwners;
select count(*)  as 'QuizToUser' from QuizToUser;
select count(*)  as 'UserMessageHistory' from UserMessageHistory;
select count(*)  as 'Users' from Users;
EOF