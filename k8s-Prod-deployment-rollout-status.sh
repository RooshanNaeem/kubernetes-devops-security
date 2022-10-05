#!/bin/bash

sleep 60s

if [[ $(kubectl -n prod rollout status deploy ${proddeploymentName}--timeout 5s) != *"successfully rolled out"* ]];
then
	echo "Deployemnt ${proddeploymentName} rollout has failed"
	kubectl -n prod rollout undo deploy ${proddeploymentName}
	exit 1;
else
	echo "Deployemnt ${proddeploymentName} rollout is Success" 

fi