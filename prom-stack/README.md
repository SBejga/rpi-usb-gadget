# Kube Prometheus Stack

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade kube-prometheus prometheus-community/kube-prometheus-stack -f values.yaml