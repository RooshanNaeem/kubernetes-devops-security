#!/bin/bash/

sed -i "s#replace#${imagaeName}#g" k8s_deployment_service.yaml
kubectl -n default get ${deploymentName} > /dev/null

if [[ $? -ne 0 ]]; 
then
	echo "deployment ${deploymentName} doesn't exist"
	kubectl -n default apply -f k8s_deployment_service.yaml
else
	echo "deployment ${deploymentName} exists" 
	echo "image name - ${imageName} doesn't exist"
	kubectl -n default set image deploy ${deploymentName} ${containerName}-${imageName} --record=true

fi