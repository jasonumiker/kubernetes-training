echo "kubectl config get-contexts"
kubectl config get-contexts
echo "--------------------"
echo "kubectl get nodes"
kubectl get nodes
echo "--------------------"
echo "cd probe-test-app"
cd probe-test-app
echo "--------------------"
echo "kubectl apply -f probe-test-app-pod.yaml"
kubectl apply -f probe-test-app-pod.yaml
kubectl wait --for=condition=ready pod probe-test-app
echo "--------------------"
echo "kubectl get pods -o wide"
kubectl get pods -o wide
echo "--------------------"
#echo "kubectl port-forward pod/probe-test-app 8080:8080"
#kubectl port-forward pod/probe-test-app 8080:8080
#echo "--------------------"
#echo "kubectl exec -it probe-test-app -- /bin/bash"
#kubectl exec -it probe-test-app -- /bin/bash
#echo "--------------------"
echo "kubectl apply -f probe-test-app-service.yaml"
kubectl apply -f probe-test-app-service.yaml
echo "--------------------"
echo "kubectl get services -o wide"
kubectl get services -o wide
echo "--------------------"
echo "kubectl get endpoints"
kubectl get endpoints
echo "--------------------"
echo "kubectl apply -f probe-test-app-pod-2.yaml"
kubectl apply -f probe-test-app-pod-2.yaml
kubectl wait --for=condition=ready pod probe-test-app-2
echo "--------------------"
echo "kubectl get endpoints"
kubectl get endpoints
echo "--------------------"
echo "kubectl delete pods --all"
kubectl delete pods --all
echo "--------------------"
echo "kubectl apply -f probe-test-app-replicaset.yaml"
kubectl apply -f probe-test-app-replicaset.
kubectl wait pods -n default -l app.kubernetes.io/name=probe-test-app --for condition=Ready
echo "--------------------"
echo "kubectl scale replicaset probe-test-app --replicas=2"
kubectl scale replicaset probe-test-app --replicas=2
kubectl wait pods -n default -l app.kubernetes.io/name=probe-test-app --for condition=Ready
echo "--------------------"
echo "kubectl delete replicaset probe-test-app"
kubectl delete replicaset probe-test-app
echo "--------------------"
echo "kubectl apply -f probe-test-app-deployment.yaml"
kubectl apply -f probe-test-app-deployment.yaml
kubectl rollout status deployment probe-test-app -n default
echo "--------------------"
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
echo "kubectl get replicasets"
kubectl get replicasets
echo "--------------------"
echo "kubectl set image deployment/probe-test-app probe-test-app=jasonumiker/probe-test-app:v2"
kubectl set image deployment/probe-test-app probe-test-app=jasonumiker/probe-test-app:v2
kubectl rollout status deployment probe-test-app -n default
echo "--------------------"
#echo "kubectl get replicasets -w"
#kubectl get replicasets -w
#echo "--------------------"
echo "kubectl events"
kubectl events
echo "--------------------"
echo "kubectl rollout undo deployment/probe-test-app"
kubectl rollout undo deployment/probe-test-app
kubectl rollout status deployment probe-test-app -n default
echo "--------------------"
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
#echo "kubectl label pod [copied pod name] app.kubernetes.io/name-"
#kubectl label pod [copied pod name] app.kubernetes.io/name-
#echo "--------------------"
#echo "kubectl get pods"
#kubectl get pods
#echo "--------------------"
echo "kubectl describe replicaset probe-test-app"
kubectl describe replicaset probe-test-app
echo "--------------------"
echo "kubectl delete deployments probe-test-app"
kubectl delete deployments probe-test-app
echo "kubectl delete service probe-test-app"
kubectl delete service probe-test-app
echo "--------------------"
echo "cd ../sidecar-and-init-containers"
cd ../sidecar-and-init-containers
#echo "--------------------"
echo "kubectl apply -f sidecar.yaml"
kubectl apply -f sidecar.yaml
kubectl wait --for=condition=ready pod pod-with-sidecar
echo "--------------------"
#kubectl exec pod-with-sidecar -c sidecar-container -it bash
#apt-get update && apt-get install curl
#curl 'http://localhost:80/app.txt'
#exit
#echo "--------------------"
echo "kubectl apply -f init.yaml"
kubectl apply -f init.yaml
echo "--------------------"
echo "kubectl get pod myapp-pod"
kubectl get pod myapp-pod
echo "--------------------"
echo "kubectl apply -f services-init-requires.yaml"
kubectl apply -f services-init-requires.yaml
echo "--------------------"
#kubectl get pod myapp-pod -w
#echo "--------------------"