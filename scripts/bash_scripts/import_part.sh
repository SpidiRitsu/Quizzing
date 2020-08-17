#!/usr/bin/env bash
dbpass=$1
file_loc=$2
mysql -u root -h localhost -p$dbpass <<EOF
USE Quizzing
SET AUTOCOMMIT=0;
SET FOREIGN_KEY_CHECKS=0;
source $file_loc;
commit;
SET FOREIGN_KEY_CHECKS=1;
EOF
echo import for $file_loc FINISHED
exit 0