# NOTE: You need to install Prometheus (in the monitoring folder) first for this to work
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
kubectl create namespace istio-system
helm install istio-base istio/base -n istio-system --set defaultRevision=default --version=1.24.0
helm install istiod istio/istiod -n istio-system --wait --version=1.24.0
kubectl create namespace istio-ingress
helm install istio-ingress istio/gateway -n istio-ingress --wait --version=1.24.0
helm repo add kiali https://kiali.org/helm-charts
helm install kiali-server -n istio-system kiali/kiali-server -f kiali-values.yaml --version=v2.1.0
kubectl apply -f prom-metrics.yaml