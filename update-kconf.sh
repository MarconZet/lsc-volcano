#!/bin/sh

aws eks update-kubeconfig --name "$(terraform output --raw cluster_name)"

# test cluster
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --create-namespace --namespace ingress \
  --set controller.replicaCount=2

# crate volcano
kubectl apply -f https://raw.githubusercontent.com/volcano-sh/volcano/master/installer/volcano-development.yaml
kubectl apply -f queue.yml
kubectl apply -f job1.yml
