#!/bin/bash

# === Colors ===
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
cyan=$(tput setaf 6)
bold=$(tput bold)
reset=$(tput sgr0)

#Keeps script running till user exits or choose the exit optin(option 8)
while true; do
	#Prints script banner
	clear
	echo "${cyan}${bold}╔══════════════════════════════════════════════════════════════╗${reset}"
	echo "${cyan}${bold}║                      WAZUH MANAGER v1.0                      ║${reset}"
	echo "${cyan}${bold}╚══════════════════════════════════════════════════════════════╝${reset}"
	echo

	#Displays the various functionalities a user can choose from
	echo "${red}${bold}1)${reset} List All Agents"
	echo "${red}${bold}2)${reset} Create New Agent Group"
	echo "${red}${bold}3)${reset} List All Groups"
	echo "${red}${bold}4)${reset} Deploy Agent (Single Host)"
	echo "${red}${bold}5)${reset} Remove Group(s)"
	echo "${red}${bold}6)${reset} View Last 20 Alerts"
	echo "${red}${bold}7)${reset} Restart Wazuh Manager"
	echo "${red}${bold}8)${reset} Exit"
	echo 

	#Takes user input on the option chosen
	while true; do
		read -p "${green}${bold}Choose an option [1-8]:${reset} " option
		if ! [[ "$option" =~ ^[1-8]$ ]]; then
			echo "${red}${bold}Error:${reset} Input must be an integer between the options above!"
		else 
			break
		fi
	done


		#Checks conditional and acts accordingly
		if [[ "$option" -eq 1 ]]; then
			#Lists all agents
			sudo /var/ossec/bin/agent_control -l
		elif [[ "$option" -eq 2 ]]; then
			#Asks user how many groups to create and take the user input
			default_num=1
			
			while true; do
				#Take user input on the number of groups to create
				read -p "${green}${bold}How many groups do you want to create [default: $default_num] :${reset} " numOfgroups
				numOfgroups=${numOfgroups:-$default_num}
				
				#Input validation for the right integer input
				if ! [[ $numOfgroups =~ ^[1-9]+ ]]; then
					echo "${red}${bold}Error:${reset} Wrong input type. Input must be a digit."
				else
					break
				fi
			done
			
			echo "Creating Groups..."
	
			for (( i=1; i<=$numOfgroups; i++ )); do
				echo 
				read -p "Enter the name of the group $i: " groupName

				#User input validation for the group name
				if ! [[ "$groupName" =~ ^[a-zA-Z0-9_-]+$ ]]; then
					echo "${red}${bold}Error:${reset} Group name must be alphanumeric with '_/-' but no spaces"

					#Checks if user input was null
					if [[ -z "$groupName" ]]; then
						echo "Group name cannot be empty"
					fi
					#Decrement the for loop counter for the useer to retry entering the group name
					((i--))
				else
					#Runs the group creation command
					result=$(sudo /var/ossec/bin/agent_groups -a -g "$groupName" 2>&1 | tee /dev/tty)
					
					#Checks for successful group creation
					if [[ "$result" =~ [Ee]rror ]] || [[ "$result" =~ "already exists" ]]; then
						#Decrements the for loop counter if indeed the group name entered already exists
						((i--))
					fi
					
				fi
			
				
			done
			echo 
			echo
		elif [[ "$option" -eq 3 ]]; then
			#Retrieves all the groups on the Wazuh
			echo "Retrieving Groups..."
			sudo /var/ossec/bin/agent_groups -l
			echo
			echo
		elif [[ "$option" -eq 4 ]]; then
			echo 
			#Prints out a help text
			echo "${red}${bold}NOTE:${reset} You will be asked to enter the name of the group to assign the"
			echo "Wazuh agent, so list all Wazuh groups first (${red}${bold}Option 3${reset}). Thank you."

			#Gets the version of the wazuh manager
			cd /var/ossec/bin/ && sudo ./wazuh-control info > output.txt
			version=$(head -n 1 output.txt | awk '{split($1, v, "v"); split(v[2], c, "\""); print c[1];}')

			#Gets the IP address of the wazuh sever/machine
			machine_ip=$(hostname -I | awk '{print $1}')

			#Asks for the agent name and the name of the group to assign the agent to
			read -p "Enter the desired name for the agent: " agent_name
			read -p "Enter the name of the group you want to assign the agent: " agent_group
			
			#Runs the wazuh agent deployment one-liner
			echo "Downloading and installing Wazuh agent..."
			sudo wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_$version-1_amd64.deb && sudo WAZUH_MANAGER='$machine_ip' WAZUH_AGENT_GROUP='$agent_group' WAZUH_AGENT_NAME='$agent_name' dpkg -i ./wazuh-agent_$version-1_amd64.deb
			sudo systemctl daemon-reload
			sudo systemctl enable wazuh-agent
			sudo systemctl start wazuh-agent
			
		elif [[ "$option" -eq 5 ]]; then
			echo
			#Prints out a help text
                        echo "${red}${bold}NOTE:${reset} You will be asked to enter the name of the group to delete."
                        echo "So list all Wazuh groups first (${red}${bold}Option 3${reset}). Thank you."
			#Set default number of groups to remove to 1
			default_remove=1
			while true; do
				#Take user input on the number of groups to remove
				read -p "How many groups do you want to remove [Default: $default_remove] : " remove_group_num
				#Sets the number of groups to remove if the user press Enter or does not enter a value
				remove_group_num=${remove_group_num:-$default_remove}
			
				#Validates user input if it is an integer
				if ! [[ "$remove_group_num" =~ ^[1-9]+ ]]; then
					echo "Error: Enter a positie integer."
				else
					break
				fi
			done
			#Loops with the number of groups specified to delete the groups
			for (( i=1; i<=$remove_group_num; i++ ));  do
			#Take name of the group to delete
				read -p "Enter the exact name of the group to be deleted: " del_group
				
				#Take the error code of from the commamd ran
				del_success=$(sudo /var/ossec/bin/agent_groups -r -g "$del_group" 2>&1 | tee /dev/tty)
				
				#Checks the error code from command ran
				if [[ "$del_success" =~ [Ee]rror ]] || [[ "$del_success" =~ "does not exist" ]]; then
				#Prints error resulting from the command ran
					#Decrements the for loop for the user to try again
					((--i))
					echo
				
				fi
			done
			echo 
		elif [[ "$option" -eq 6 ]]; then
			echo "Wazuh Alerts"
			
			#Install json query for better view of the alerts displayed
			sudo apt install jq

			#Displays the last 20 alerts in json format
			sudo tail -n 20 /var/ossec/logs/alerts/alerts.json | jq

		elif [[ "$option" -eq 7 ]]; then
			#Restarts the wazuh manager
			echo "Restarting Wazuh Manager..."
			output=$(sudo systemctl restart wazuh-manager 2>&1)
			if [[ $? -eq 0 ]]; then
				echo "Wazuh Manager successfully restarted!"
			else
				echo "Error: $output"
			fi
			echo

		elif [[ "$option" -eq 8 ]]; then
			#Exits the script
			echo "${green}${bold}Goodbye! Stay secure!!${reset}"
			exit 0
		fi
		read -p $"${green}${bold}Press Enter to return to menu...${reset}"
done
	
