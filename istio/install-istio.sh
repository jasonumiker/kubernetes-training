# NOTE: You need to install Prometheus (in the monitoring folder) first for this to work
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
kubectl create namespace istio-system
helm install istio-base istio/base -n istio-system --set defaultRevision=default --version=1.25.1
helm install istiod istio/istiod -n istio-system --wait --version=1.25.1
# We're using the Gateway API so don't need the Istio Ingress Gateway
#kubectl create namespace istio-ingress
#helm install istio-ingress istio/gateway -n istio-ingress --wait --version=1.25.1
helm repo add kiali https://kiali.org/helm-charts
helm install kiali-server -n istio-system kiali/kiali-server -f kiali-values.yaml --version=v2.8.0
kubectl apply -f prom-metrics.yaml
kubectl apply -f gateway-api-crds.yaml