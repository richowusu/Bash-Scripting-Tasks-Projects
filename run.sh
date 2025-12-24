#!/bin/bash

echo "============================="
echo "Wazuh Group Creator Script."
echo "============================="

echo "_"
echo "        /_/"
echo "       / /"
echo "      / /_"
echo "     / // /"
echo "    / // /"
echo "   / / /"
echo "  /_/"
echo "Names given to groups created must be alphanumeric ONLY and should not include spaces."

#Takes input for the number of wazuh groups to be created
echo -e "\nEnter the number of groups you want to create: "
read numOfGroups
echo -e "\nYou want to create $numOfGroups groups."

#Checks if the input is a positive integer
if ! [[ "$numOfGroups" =~ ^[0-9]+$ ]] || [[ "$numOfGroups" -le 0 ]]; then
	echo "Error: Enter a positive integer."
	exit 1
fi

#This for loop block takes the desired group name and creates the group 
for (( i=0; i<$numOfGroups; i++)); do
	echo -e "\nEnter the desired name for the Wazuh Group you want to create: "
	read wazuhName
	
	if ! [[ "$wazuhName" =~ ^[a-zA-Z0-9]+$ ]]; then
		echo "Error: Group name must be alphanumeric only (no spaces or special characters)."
		((i--))
		continue
	fi
	
	#Progress message
	echo "Creating Wazuh Group '$wazuhName'..."
	
	#Changing directory to /var/ossec/bin
	result=$(sudo bash -c "cd /var/ossec/bin && ./agent_groups -a -g $wazuhName -q 2>&1")
        
        if [[ $? -eq 0 ]]; then
        	echo "Wazuh Group '$wazuhName' created successfully!!"
        else
        	echo "Error creating group '$wazuhName': $result"
        fi
done

echo -e "\nScript complete!"


