# Kube Prometheus Stack

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade -i kube-prometheus prometheus-community/kube-prometheus-stack -f prom-values.yaml