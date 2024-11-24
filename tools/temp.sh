echo "--------------------"
cd kustomize
echo "helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts"
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
echo "--------------------"
sleep 1
echo "helm install gatekeeper/gatekeeper --name-template=gatekeeper --namespace gatekeeper-system --create-namespace --version 3.17.1"
helm install gatekeeper/gatekeeper --name-template=gatekeeper --namespace gatekeeper-system --create-namespace --version 3.17.1
echo "--------------------"
sleep 10
echo "cd ../opa-gatekeeper"
cd ../opa-gatekeeper
echo "--------------------"
sleep 1
echo "kubectl apply -f k8srequiredlabels-constraint-template.yaml"
kubectl apply -f k8srequiredlabels-constraint-template.yaml
echo "--------------------"
sleep 1
echo "kubectl apply -f pods-in-default-must-have-owner.yaml"
kubectl apply -f pods-in-default-must-have-owner.yaml
echo "--------------------"
sleep 10
echo "kubectl apply -f ../probe-test-app/probe-test-app-pod.yaml"
kubectl apply -f ../probe-test-app/probe-test-app-pod.yaml
echo "--------------------"
sleep 1
echo "kubectl apply -f probe-test-app-pod.yaml"
kubectl apply -f probe-test-app-pod.yaml
echo "--------------------"
sleep 1
echo "kubectl delete constraint pods-in-default-must-have-owner"
kubectl delete constraint pods-in-default-must-have-owner
echo "--------------------"
sleep 1
echo "kubectl delete pod probe-test-app"
kubectl delete pod probe-test-app
echo "--------------------"
sleep 1
echo "helm repo add argo-helm https://argoproj.github.io/argo-helm"
helm repo add argo-helm https://argoproj.github.io/argo-helm
echo "--------------------"
sleep 1
echo "helm install argo-cd argo-helm/argo-cd --namespace argocd --create-namespace --version 7.6.1"
helm install argo-cd argo-helm/argo-cd --namespace argocd --create-namespace --version 7.6.1
echo "--------------------"
sleep 10
echo "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo "--------------------"
sleep 10
echo "cd ../argocd"
cd ../argocd
echo "--------------------"
sleep 1
echo "kubectl apply -f probe-test-app.yaml -n argocd"
kubectl apply -f probe-test-app.yaml -n argocd
echo "--------------------"
sleep 1
echo "kubectl apply -f argo-rollouts-app.yaml -n argocd"
kubectl apply -f argo-rollouts-app.yaml -n argocd
echo "--------------------"
sleep 1
echo "kubectl delete deployment probe-test-app"
kubectl delete deployment probe-test-app
echo "--------------------"
sleep 1
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
sleep 1
echo "kubectl delete application probe-test-app -n argocd"
kubectl delete application probe-test-app -n argocd