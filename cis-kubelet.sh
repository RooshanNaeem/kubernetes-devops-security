#!/bin/bash


result= $(kube-bench run --targets node --version 1.15 --check 4.2.1,4.2.2 --json | jq .[].total_fail)

if [[ "$result" -ne 0  ]];
	then
		echo "CIS Benchmark failed for testing Kubelet for checks 4.2.1,4.2.2"
		exit 1;
	else
		echo "CIS Benchmark passed for Kubelet - 4.2.1,4.2.2"

fi;	