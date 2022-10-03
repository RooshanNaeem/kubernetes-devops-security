#!/bin/bash

sleep 60s

if [[ $(kubectl -n prod rollout status deploy ${deploymentName} --timeout 5s) != *"successfully rolled out"* ]];
then
	echo "Deployemnt ${deploymentName} rollout has failed"
	kubectl -n prod rollout undo deploy ${deploymentName}
	exit 1;
else
	echo "Deployemnt ${deploymentName} rollout is Success" 

fi