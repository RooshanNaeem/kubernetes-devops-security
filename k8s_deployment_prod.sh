#!/bin/bash

sed -i "s#replace#${imageName}#g" k8s_Prod_deployment_service.yaml
kubectl -n prod get deployment/${deploymentName}

if [[ $? -ne 0 ]]; 
then
	echo "deployment ${deploymentName} doesn't exist"
	kubectl -n prod apply -f k8s_Prod_deployment_service.yaml
else
	echo "deployment ${deploymentName} exists" 
	echo "image name - ${imageName}"
	kubectl -n prod set image deploy ${deploymentName} ${containerName}=${imageName} --record=true

fi
#kubectl -n default apply -f k8s_deployment_service.yaml