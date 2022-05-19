#!/bin/bash
script -q ./logs/$1
if [ $2 = "linux" ]
then
	cd /home/orchestrator/openstack/orchestration/terraform_linux
	. creds.sh
	rm terraform.tfstate*
	terraform plan -var="name=$1"
	terraform apply -var="name=$1" -auto-approve
	sleep 120
	cd ../ansible
	ansible-playbook -i hosts linux_playbook.yml --extra-vars "machinename=$1"
elif [ $2 = "windows" ]
then
	cd /home/orchestrator/openstack/orchestration/terraform_windows
	. creds.sh
	rm terraform.tfstate*
	terraform plan -var="name=$1"
	terraform apply -var="name=$1" -auto-approve
	sleep 600
	cd ../ansible
	ansible-playbook -i hosts windows_playbook.yml --extra-vars "machinename=$1"
else
	echo "bad arguments"
fi
