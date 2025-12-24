#!/bin/bash

echo "============================================================="
echo "||							   ||"
echo "||     This is a script to check user password strength    ||"
echo "||							   ||"
echo "============================================================="

echo -e "\nEnter a new password for checking: "
read -s pass
echo 

criteria=""
score=0
pass_len=${#pass}

if [[ $pass_len -lt 8 ]]; then
	criteria+="Password is too short. \n"
else
	((score++))
fi

if [[ ! "$pass" =~ [a-z] ]]; then
	criteria+="Password must contain a lowercase letter. \n"
else
	((score++))
fi

if [[ ! "$pass" =~ [A-Z] ]]; then
	criteria+="Password must contain an uppercase letter. \n"
else 
	((score++))
fi

if [[ ! "$pass" =~ [0-9] ]]; then
	criteria+="Password must contain a number. \n"
else
	((score++))
fi

if [[ ! "$pass" =~ [[:punct:]] ]]; then
	criteria+="Password must contain a symbol. \n"
else
	((score++))
fi

echo -e "\nPassword Analysis..."
if [[ -n "$criteria" ]]; then
	echo -e "Issues: \n$criteria"
else 
	echo "No issues found!"
fi

case $score in 
	0|1) echo "Strength: WEAK 🚫️ (Score: $score/5)." ;;
	2|3) echo "Strength: MEDIUM ⚠️ (Score: $score/5)." ;;
	4|5) echo "Strength: STRONG ✅️ (Score: $score/5)." ;;
esac
