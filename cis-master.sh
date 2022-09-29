#!/bin/bash


total_fail= $(kube-bench run --targets master --version 1.15 --check 1.2.7,1.2.8,1.2.9 --json | jq '.[].total_fail')

if [[ "$total_fail" -ne 0  ]];
	then
		echo "CIS Benchmark failed for testing Master for checks 1.2.7, 1.2.8, 1.2.9"
		exit 1;
	else
		echo "CIS Benchmark passed for master - 1.2.7, 1.2.8, 1.2.9"

fi;	