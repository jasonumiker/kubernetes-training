helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress ingress-nginx/ingress-nginx --set controller.allowSnippetAnnotations=true --set controller.config.annotations-risk-level=Critical --version=4.12.1