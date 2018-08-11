#!/bin/bash

clusterName="test-cv4faces-cluster"
releaseName="test-cv4faces-jupyterhub"

gcloud components install kubectl

gcloud container clusters create $clusterName \
--num-nodes=3 \
--machine-type=n1-standard-2 \
--zone=us-central1-b

sleep 10s

kubectl create clusterrolebinding cluster-admin-binding \
--clusterrole=cluster-admin \
--user=vishweshshrimali5@gmail.com

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
kubectl --namespace kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
#helm version
kubectl --namespace=kube-system patch deployment tiller-deploy --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
helm install jupyterhub/jupyterhub \
    --version=v0.6 \
    --name=$releaseName \
    --namespace=$releaseName \
    --timeout=9999 \
    -f config.yaml

kubectl --namespace=$releaseName get pod

sleep 10s

kubectl --namespace=$releaseName get svc
