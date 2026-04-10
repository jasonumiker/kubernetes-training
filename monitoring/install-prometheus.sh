./docker-desktop-update.sh
sleep 10
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack --values prometheus-stack-values.yaml --version 83.3.0 -n monitoring
helm install adapter prometheus-community/prometheus-adapter --values prometheus-adapter-values.yaml --version 5.3.0 -n monitoring