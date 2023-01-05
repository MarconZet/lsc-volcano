#!/bin/zsh

aws eks update-kubeconfig --name "$(terraform output --raw cluster_name)"
k apply -f https://raw.githubusercontent.com/volcano-sh/volcano/master/installer/volcano-development.yaml
k apply -f queue.yml
k apply -f job1.yml