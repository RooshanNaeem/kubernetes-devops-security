#!/bin/bash


total_fail= $(kube-bench run --targets etcd --version 1.15 --check 2.2 --json | jq .[].tatl_fail)

if [[ "$total_fail" -ne 0  ]];
	then
		echo "CIS Benchmark failed for testing Etcd for check 2.2"
		exit 1;
	else
		echo "CIS BEnchmark passed for Etcd - 2.2"

fi;	