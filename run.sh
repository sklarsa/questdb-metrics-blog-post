#! /bin/bash

set -euo pipefail

kind create cluster -n questdb-metrics-example

## Add required helm repos
helm repo add questdb https://helm.questdb.io/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add influxdata https://helm.influxdata.com/
helm repo update

## Install QuestDB and enable InfluxDB Line Protocol
helm upgrade -i questdb questdb/questdb \
    -n questdb \
    --create-namespace \
    --set service.expose.influxdb.enabled=true

## Install Telegraf and configure it to to listen to Prometheus and write to QuestDB
kubectl create namespace telegraf
kubectl apply -f starlark-configmap.yaml

helm upgrade -i telegraf influxdata/telegraf \
    -n telegraf \
    -f telegraf-values.yaml \
    --set image.tag=1.25 # TODO: remove this once alpine is working!

## Install Prometheus
helm upgrade -i prometheus prometheus-community/prometheus \
    -n prometheus \
    --create-namespace \
    --set 'server.remoteWrite[0].url=http://telegraf.telegraf.svc:9999/write'


echo "Wait a minute or so until all pods are Ready, then open a port-forward to QuestDB's frontend:"
echo "kubectl port-forward service/questdb -n questdb 9000:9000"
