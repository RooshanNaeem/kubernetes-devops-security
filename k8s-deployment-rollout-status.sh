#!/bin/bash

sleep 60s

if [[ $(kubectl -n default rollout status deploy ${deploymentName} --timeout 5s) != *"successfullty rolled out"* ]];
then
	echo "Deployemnt ${deploymentName} rollout has failed"
	kubectl -n default rollout undo deploy ${deploymentName}
	exit 1;
else
	echo "Deployemnt ${deploymentName} rollout is Success" 

fi