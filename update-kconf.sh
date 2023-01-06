#!/bin/zsh

aws eks update-kubeconfig --name "$(terraform output --raw cluster_name)"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --create-namespace --namespace ingress \
  --set controller.replicaCount=2
k apply -f https://raw.githubusercontent.com/volcano-sh/volcano/master/installer/volcano-development.yaml
k apply -f queue.yml
k apply -f job1.yml
