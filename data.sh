#!/bin/bash

echo "\033[0;31mSample Output\033[0m"

echo "\033[0;32mAssignment 1 - a \033[0m"
echo "HTTP_STATUS" ;cat access-log.txt |  awk -F ' ' '{print $9}' | sort -rd | uniq -c | awk ' { t = $1; $1 = $2; $2 = t; print $1,"- "$2} '

echo "\033[0;32mAssignment 1 - b \033[0m"
echo "UNIQUE-CLIENT-ADDRESS";cat access-log.txt|  awk -F ' ' '{print $1}' |uniq -c |awk ' { t = $1; $1 = $2; $2 = t; print $1,"- "$2} '
echo "UNIQUE-CLIENT-ADDRESS";cat access-log.txt|  awk -F ' ' '{print $1}' |uniq -c |awk ' { t = $1; $1 = $2; $2 = t; print $1,"- "$2} '| wc -l

echo "\033[0;32mAssignment 1 - c \033[0m"
echo "Line_Number | Count"
awk '{ print NR,"| "NF }' access-log.txt
