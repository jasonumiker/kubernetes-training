helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress ingress-nginx/ingress-nginx --version=4.11.3