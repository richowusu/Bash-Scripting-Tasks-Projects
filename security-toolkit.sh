#!/bin/bash

# Colors and Formatting
red=$(tput setaf 1)   
green=$(tput setaf 2)   
yellow=$(tput setaf 3)
blue=$(tput setaf 4) 
magenta=$(tput setaf 5) 
cyan=$(tput setaf 6)
bold=$(tput bold)
reset=$(tput sgr0)

logo() {
    clear
    echo
    echo "${cyan}${bold}┌─────────────────────────────────────────────────────────────┐${reset}"
    echo "${cyan}${bold}│                                                             │${reset}"
    echo "${cyan}${bold}│    ███████╗███████╗ ██████╗██╗   ██╗██████╗ ██╗████████╗    │${reset}"
    echo "${cyan}${bold}│    ██╔════╝██╔════╝██╔════╝██║   ██║██╔══██╗██║╚══██╔══╝    │${reset}"
    echo "${cyan}${bold}│    ███████╗█████╗  ██║     ██║   ██║██████╔╝██║   ██║       │${reset}"
    echo "${cyan}${bold}│    ╚════██║██╔══╝  ██║     ██║   ██║██╔══██╗██║   ██║       │${reset}"
    echo "${cyan}${bold}│    ███████║███████╗╚██████╗╚██████╔╝██║  ██║██║   ██║       │${reset}"
    echo "${cyan}${bold}│    ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝       │${reset}"
    echo "${cyan}${bold}│                                                             │${reset}"
    echo "${cyan}${bold}│     ████████╗ ██████╗  ██████╗ ██╗     ██╗  ██╗██╗████████╗ │${reset}"
    echo "${cyan}${bold}│     ╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██║ ██╔╝██║╚══██╔══╝ │${reset}"
    echo "${cyan}${bold}│        ██║   ██║   ██║██║   ██║██║     █████╔╝ ██║   ██║    │${reset}"
    echo "${cyan}${bold}│        ██║   ██║   ██║██║   ██║██║     ██╔═██╗ ██║   ██║    │${reset}"
    echo "${cyan}${bold}│        ██║   ╚██████╔╝╚██████╔╝███████╗██║  ██╗██║   ██║    │${reset}"
    echo "${cyan}${bold}│        ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝   ╚═╝    │${reset}"
    echo "${cyan}${bold}│                                                             │${reset}"
    echo "${cyan}${bold}│                   ${white}${bold}SECURITY TOOLKIT${reset}${cyan}                    │${reset}"
    echo "${cyan}${bold}│                         ${white}${bold}v2.0${reset}${cyan}                         │${reset}"
    echo "${cyan}${bold}│                                                            │${reset}"
    echo "${cyan}${bold}│          ${yellow}\"Master of tput, Color, and Clarity\"${reset}${cyan}         │${reset}"
    echo "${cyan}${bold}│                                                            │${reset}"
    echo "${cyan}${bold}└────────────────────────────────────────────────────────────┘${reset}"
    echo
}

while true; do
	
	#echo -e "${cyan}${bold}\n==========================================================${reset}"
	#echo "${cyan}${bold}		  Security Toolkit v1.0	                        ${reset}"
	#echo "${cyan}${bold}==========================================================${reset}"
	logo
	
	echo -e "\n${red}${bold}1)${reset} Check Password Strength"
	echo "${red}${bold}2)${reset} Generate Strong Password"
	echo "${red}${bold}3)${reset} Scan Open Ports (localhost)"
	echo "${red}${bold}4)${reset} Check Failed Logins (last 20)"
	echo "${red}${bold}5)${reset} Exit"


	min_value=1
	max_value=5
	while true; do
		read -p $'\nChoose an option [1-5]: ' option
		if [[ $option != [0-9] ]]; then
			echo "Please enter a digit."
		elif (( $option < $min_value || $option > $max_value )); then
			echo "Enter a number within the range, 1-5."
		else
			break
		fi
	done

	if [[ $option -eq 1 ]]; then
		clear
		score=0
		criteria=""
		echo "${cyan}${bold}=== Password Strength Checker ===${reset}"
		read -s -p "Enter a password of choice: " pass
		pass_len=${#pass}
		
		if [[ $pass_len -lt 8 ]]; then
			criteria+="\nPassword is too short."
		else
			((score++))
		fi
		if [[ "$pass" =~ [0-9] ]]; then
			((score++))
		else
			criteria+="\nPassword must include a digit."
		fi
		if [[ "$pass" =~ [A-Z] ]]; then
			((score++))
		else
			criteria+="\nPassword must include uppercase letter."
		fi
		if [[ "$pass" =~ [a-z] ]]; then
			((score++))
		else
			criteria+="\nPassword must include a lowercase letter."
		fi
		if [[ "$pass" =~ [[:punct:]] ]]; then
			((score++))
		else
			criteria+="\nPassword must include a symbol."
		fi
		
		echo -e "\nPassword Analysis..."
		if [[ -n "$criteria" ]]; then
			echo -e "\nIssues: ${red}${bold}$criteria${reset}"
		else
			echo -e "\nNo issues found👍️."
		fi
		
		case $score in
			0|1|2) echo "Strength: ${red}${bold}WEAK${reset} 🚫️. Score: $score/5." ;;
			3|4) echo "Strength: ${yellow}${bold}MEDIUM${reset} ⚠️. Score: $score/5." ;;
			5) echo "Strength: ${green}${bold}STRONG${reset} ✅️. Score: $score/5." ;;
		esac
		
		read -p $"${bold}${green}Press Enter to return to menu...${reset}"
		
	elif [[ $option -eq 2 ]]; then
		clear	
		echo "${cyan}${bold}=== Generate Strong Password ===${reset}"
		while true; do
			read -p $'\nSpecify your desired password length(min 8): ' length
		
			if [[ $length -lt 8 ]]; then
				echo "Enter a value greater than or equal to 8." 
			else
				break
			fi
		done
		spass=$(tr -dc 'A-Za-z0-9!?%=$#@&,.;:@+' < /dev/urandom | head -c $length)
		echo -e "\nYour generated strong password is ${green}${bold}$spass${reset}"
		
		read -p $"${bold}${green}Press Enter to return to menu...${reset}"
	elif [[ $option -eq 3 ]]; then
		clear
		echo "${cyan}${bold}=== Scanning Open Ports (localhost) ===${reset}"
		
		sudo nmap -T4 -sV localhost
		
	    	read -p $"${bold}${green}Press Enter to return to menu...${reset}"
	elif [[ $option -eq 4 ]]; then
		clear
		echo "${cyan}${bold}=== The last 20 failed logins ===${reset}"
		grep -i "failed\|invalid\|authentication failure" /var/log/auth.log | tail -n 20
		
		read -p $"${bold}${green}Press Enter to return to menu...${reset}"
	elif [[ $option -eq 5 ]]; then
		clear
		echo -e "${yellow}${bold}\nGoodbye! Stay secure!${reset}\n"
		exit 0
	fi	
done
