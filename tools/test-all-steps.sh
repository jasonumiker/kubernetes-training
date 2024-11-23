# Run this from the parent folder with a ./tools/test-all-steps.sh
echo "kubectl config get-contexts"
kubectl config get-contexts
echo "--------------------"
sleep 1
echo "kubectl get nodes"
kubectl get nodes
echo "--------------------"
sleep 1
echo "cd probe-test-app"
cd probe-test-app
echo "--------------------"
sleep 1
echo "kubectl apply -f probe-test-app-pod.yaml"
kubectl apply -f probe-test-app-pod.yaml
kubectl wait --for=condition=ready pod probe-test-app
echo "--------------------"
sleep 1
echo "kubectl get pods -o wide"
kubectl get pods -o wide
echo "--------------------"
#sleep 1
#echo "kubectl port-forward pod/probe-test-app 8080:8080"
#kubectl port-forward pod/probe-test-app 8080:8080
#echo "--------------------"
#echo "kubectl exec -it probe-test-app -- /bin/bash"
#kubectl exec -it probe-test-app -- /bin/bash
#echo "--------------------"
sleep 1
echo "kubectl apply -f probe-test-app-service.yaml"
kubectl apply -f probe-test-app-service.yaml
echo "--------------------"
sleep 1
echo "kubectl get services -o wide"
kubectl get services -o wide
echo "--------------------"
sleep 1
echo "kubectl get endpoints"
kubectl get endpoints
echo "--------------------"
sleep 1
echo "kubectl apply -f probe-test-app-pod-2.yaml"
kubectl apply -f probe-test-app-pod-2.yaml
kubectl wait --for=condition=ready pod probe-test-app-2
echo "--------------------"
sleep 1
echo "kubectl get endpoints"
kubectl get endpoints
echo "--------------------"
sleep 1
echo "kubectl delete pods --all"
kubectl delete pods --all
echo "--------------------"
sleep 1
echo "kubectl apply -f probe-test-app-replicaset.yaml"
kubectl apply -f probe-test-app-replicaset.yaml
kubectl wait pods -n default -l app.kubernetes.io/name=probe-test-app --for condition=Ready
echo "--------------------"
sleep 1
echo "kubectl scale replicaset probe-test-app --replicas=2"
kubectl scale replicaset probe-test-app --replicas=2
echo "--------------------"
sleep 1
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
sleep 1
echo "kubectl delete replicaset probe-test-app"
kubectl delete replicaset probe-test-app
echo "--------------------"
sleep 1
echo "kubectl apply -f probe-test-app-deployment.yaml"
kubectl apply -f probe-test-app-deployment.yaml
kubectl rollout status deployment probe-test-app -n default
echo "--------------------"
sleep 1
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
sleep 1
echo "kubectl get replicasets"
kubectl get replicasets
echo "--------------------"
sleep 1
echo "kubectl set image deployment/probe-test-app probe-test-app=jasonumiker/probe-test-app:v2"
kubectl set image deployment/probe-test-app probe-test-app=jasonumiker/probe-test-app:v2
kubectl rollout status deployment probe-test-app -n default
echo "--------------------"
sleep 1
#echo "kubectl get replicasets -w"
#kubectl get replicasets -w
#echo "--------------------"
sleep 1
echo "kubectl events"
kubectl events
echo "--------------------"
sleep 1
echo "kubectl rollout undo deployment/probe-test-app"
kubectl rollout undo deployment/probe-test-app
kubectl rollout status deployment probe-test-app -n default
echo "--------------------"
sleep 1
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
sleep 1
#echo "kubectl label pod [copied pod name] app.kubernetes.io/name-"
#kubectl label pod [copied pod name] app.kubernetes.io/name-
#echo "--------------------"
sleep 1
#echo "kubectl get pods"
#kubectl get pods
#echo "--------------------"
sleep 1
echo "kubectl describe replicaset probe-test-app"
kubectl describe replicaset probe-test-app
echo "--------------------"
sleep 1
echo "cd ../sidecar-and-init-containers"
cd ../sidecar-and-init-containers
echo "--------------------"
sleep 1
echo "kubectl apply -f sidecar.yaml"
kubectl apply -f sidecar.yaml
kubectl wait --for=condition=ready pod pod-with-sidecar
echo "--------------------"
sleep 1
#kubectl exec pod-with-sidecar -c sidecar-container -it bash
#apt-get update && apt-get install curl
#curl 'http://localhost:80/app.txt'
#exit
#echo "--------------------"
sleep 1
echo "kubectl apply -f init.yaml"
kubectl apply -f init.yaml
echo "--------------------"
sleep 1
echo "kubectl get pod myapp-pod"
kubectl get pod myapp-pod
echo "--------------------"
sleep 1
echo "kubectl apply -f services-init-requires.yaml"
kubectl apply -f services-init-requires.yaml
sleep 10
echo "--------------------"
sleep 1
#kubectl get pod myapp-pod -w
kubectl get pod myapp-pod
echo "--------------------"
sleep 1
kubectl delete pod myapp-pod
kubectl delete pod pod-with-sidecar
kubectl delete service myservice
kubectl delete service mydb
echo "--------------------"
sleep 1
echo "cd ../pvs-and-statefulsets"
cd ../pvs-and-statefulsets
echo "--------------------"
sleep 1
echo "kubectl apply -f hostpath-provisioner.yaml"
kubectl apply -f hostpath-provisioner.yaml
echo "--------------------"
sleep 1
echo "kubectl get storageclass"
kubectl get storageclass
echo "--------------------"
sleep 1
echo "kubectl apply -f pvc.yaml"
kubectl apply -f pvc.yaml
echo "--------------------"
sleep 1
echo "kubectl get pvc"
kubectl get pvc
echo "--------------------"
sleep 1
echo "kubectl apply -f pod.yaml"
kubectl apply -f pod.yaml
kubectl wait --for=condition=ready pod nginx
echo "--------------------"
sleep 1
echo "kubectl get pvc"
kubectl get pvc
echo "--------------------"
sleep 1
echo "kubectl get pv"
kubectl get pv
echo "--------------------"
sleep 1
echo "kubectl apply -f service.yaml"
kubectl apply -f service.yaml
sleep 10
echo "--------------------"
sleep 1
echo "curl http://localhost:8001"
curl http://localhost:8001
echo "--------------------"
sleep 1
echo "kubectl exec -it nginx  -- bash -c \"echo 'Data on PV' > /usr/share/nginx/html/index.html\""
kubectl exec -it nginx  -- bash -c "echo 'Data on PV' > /usr/share/nginx/html/index.html"
echo "--------------------"
sleep 1
echo "curl http://localhost:8001"
curl http://localhost:8001
echo "--------------------"
sleep 1
echo "kubectl delete pod nginx"
kubectl delete pod nginx
echo "--------------------"
sleep 1
echo "kubectl get pv"
kubectl get pv
echo "--------------------"
sleep 1
echo "kubectl apply -f pod.yaml"
kubectl apply -f pod.yaml
kubectl wait --for=condition=ready pod nginx
echo "--------------------"
sleep 1
echo "curl http://localhost:8001"
curl http://localhost:8001
echo "--------------------"
sleep 1
echo "kubectl delete service nginx"
kubectl delete service nginx
echo "--------------------"
sleep 1
echo "kubectl delete pod nginx"
kubectl delete pod nginx
echo "--------------------"
sleep 1
echo "kubectl delete pvc test-pvc"
kubectl delete pvc test-pvc
echo "--------------------"
sleep 1
echo "kubectl get pv"
kubectl get pv
echo "--------------------"
sleep 1
cd ../keda-example/rabbitmq
echo "--------------------"
sleep 1
echo "kubectl apply -k ."
kubectl apply -k .
kubectl rollout status statefulset/rabbitmq
echo "--------------------"
sleep 1
echo "kubectl describe statefulset rabbitmq"
kubectl describe statefulset rabbitmq
echo "--------------------"
sleep 1
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
sleep 1
echo "kubectl get pvc"
kubectl get pvc
echo "--------------------"
sleep 1
echo "kubectl get pv"
kubectl get pv
echo "--------------------"
sleep 1
echo "kubectl delete pod rabbitmq-0"
kubectl delete pod rabbitmq-0
echo "--------------------"
sleep 1
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
sleep 1
echo "cd ../../monitoring"
cd ../../monitoring
echo "--------------------"
sleep 1
echo "./install-prometheus.sh"
./install-prometheus.sh
sleep 10
kubectl rollout status deployment adapter-prometheus-adapter -n monitoring
sleep 60
echo "--------------------"
sleep 1
echo "kubectl top nodes"
kubectl top nodes
echo "--------------------"
sleep 1
echo "kubectl top pods"
kubectl top pods
echo "--------------------"
sleep 1
echo "kubectl top pods -n monitoring"
kubectl top pods -n monitoring
echo "--------------------"
sleep 1
echo "cd ../probe-test-app"
cd ../probe-test-app
echo "--------------------"
sleep 1
echo "kubectl apply -f probe-test-app-hpa.yaml"
kubectl apply -f probe-test-app-hpa.yaml
echo "--------------------"
sleep 1
echo "kubectl apply -f generate-load-app-replicaset.yaml"
kubectl apply -f generate-load-app-replicaset.yaml
sleep 30
echo "--------------------"
sleep 1
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
sleep 1
echo "kubectl delete replicaset generate-load-app"
kubectl delete replicaset generate-load-app
sleep 30
echo "--------------------"
sleep 1
echo "kubectl describe hpa probe-test-app"
kubectl describe hpa probe-test-app
echo "--------------------"
sleep 1
echo "cd ../limit-examples"
cd ../limit-examples
echo "--------------------"
sleep 1
echo "kubectl apply -f cpu-stressor.yaml"
kubectl apply -f cpu-stressor.yaml
kubectl rollout status deployment cpu-stressor -n default
echo "--------------------"
sleep 1
#kubectl edit deployment cpu-stressor
#echo "--------------------"
sleep 1
echo "kubectl delete deployment cpu-stressor"
kubectl delete deployment cpu-stressor
echo "--------------------"
sleep 1
echo "kubectl apply -f memory-stressor.yaml"
kubectl apply -f memory-stressor.yaml
sleep 10
echo "--------------------"
sleep 1
#kubectl get pods -w
#echo "--------------------"
sleep 1
echo "kubectl delete pod memory-stressor"
kubectl delete pod memory-stressor
echo "--------------------"
sleep 1
echo "cd ../keda-example"
cd ../keda-example
echo "--------------------"
sleep 1
echo "./install-keda.sh"
./install-keda.sh
sleep 10
echo "--------------------"
sleep 1
echo "kubectl apply -f consumer.yaml"
kubectl apply -f consumer.yaml
echo "--------------------"
sleep 1
echo "kubectl apply -f keda-scaled-object.yaml"
kubectl apply -f keda-scaled-object.yaml
echo "--------------------"
sleep 1
echo "kubectl apply -f publisher.yaml"
kubectl apply -f publisher.yaml
echo "--------------------"
sleep 1
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
sleep 1
echo "kubectl events"
kubectl events
echo "--------------------"
sleep 1
echo "kubectl describe job rabbitmq-publish"
kubectl describe job rabbitmq-publish
echo "--------------------"
sleep 1
echo "cd ../cronjob"
cd ../cronjob
echo "--------------------"
sleep 1
echo "kubectl apply -f cronjob.yaml"
kubectl apply -f cronjob.yaml
sleep 125
echo "--------------------"
sleep 1
#k9s
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
sleep 1
echo "kubectl get cronjob"
kubectl get cronjob
echo "--------------------"
sleep 1
echo "kubectl delete cronjob hello"
kubectl delete cronjob hello
echo "--------------------"
sleep 1
echo "kubectl get pods -A"
kubectl get pods -A
echo "--------------------"
sleep 1
echo "kubectl api-resources"
kubectl api-resources
echo "--------------------"
sleep 1
echo "kubectl get clusterrole admin -o yaml"
kubectl get clusterrole admin -o yaml
echo "--------------------"
sleep 1
echo "kubectl get clusterrole admin -o yaml | wc -l"
kubectl get clusterrole admin -o yaml | wc -l
echo "--------------------"
sleep 1
echo "cd ../k8s-authz"
cd ../k8s-authz
echo "--------------------"
sleep 1
echo "./setup-tokens-on-cluster.sh"
./setup-tokens-on-cluster.sh
echo "--------------------"
sleep 1
echo "./add-users-kubeconfig.sh"
./add-users-kubeconfig.sh
echo "--------------------"
sleep 1
echo "cat team1.yaml"
cat team1.yaml
echo "--------------------"
sleep 30
echo "kubectl apply -f team1.yaml && kubectl apply -f team2.yaml"
kubectl apply -f team1.yaml && kubectl apply -f team2.yaml
echo "--------------------"
sleep 1
echo "kubectl config get-contexts"
kubectl config get-contexts
echo "--------------------"
sleep 1
echo "kubectl config use-context docker-desktop-jane"
kubectl config use-context docker-desktop-jane
echo "--------------------"
sleep 1
echo "kubectl get pods -A"
kubectl get pods -A
echo "--------------------"
sleep 1
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
sleep 1
echo "kubectl config use-context docker-desktop-john"
kubectl config use-context docker-desktop-john
echo "--------------------"
sleep 1
echo "kubectl get pods"
kubectl get pods
echo "--------------------"
sleep 1
echo "kubectl get pods --namespace=team1"
kubectl get pods --namespace=team1
echo "--------------------"
sleep 1
echo "kubectl config use-context docker-desktop"
kubectl config use-context docker-desktop
echo "--------------------"
sleep 1
echo "cd ../ingress"
cd ../ingress
echo "--------------------"
sleep 1
echo "./install-nginx.sh"
./install-nginx.sh
sleep 30
echo "--------------------"
sleep 1
echo "kubectl apply -f probe-test-app-ingress.yaml"
kubectl apply -f probe-test-app-ingress.yaml
sleep 10
echo "--------------------"
sleep 1
echo "curl http://localhost"
curl http://localhost
echo "--------------------"
sleep 1
echo "kubectl apply -f nyancat.yaml"
kubectl apply -f nyancat.yaml
echo "--------------------"
sleep 1
echo "kubectl rollout status deployment nyancat -n default"
kubectl rollout status deployment nyancat -n default
echo "--------------------"
sleep 1
echo "kubectl apply -f nyancat-ingress.yaml"
kubectl apply -f nyancat-ingress.yaml
echo "--------------------"
sleep 1
echo "curl http://localhost/nyancat/"
curl http://localhost/nyancat/
echo "--------------------"
sleep 1
echo "kubectl delete ingress probe-test-app"
kubectl delete ingress probe-test-app
echo "--------------------"
sleep 1
echo "helm uninstall ingress"
helm uninstall ingress
echo "--------------------"
sleep 1
echo "cd ../istio"
cd ../istio
echo "--------------------"
sleep 1
echo "./install-istio.sh"
./install-istio.sh
sleep 30
echo "--------------------"
sleep 1
echo "kubectl label namespace default istio-injection=enabled"
kubectl label namespace default istio-injection=enabled
echo "--------------------"
sleep 1
echo "kubectl apply -f bookinfo/platform/kube/bookinfo.yaml"
kubectl apply -f bookinfo/platform/kube/bookinfo.yaml
echo "--------------------"
sleep 1
echo "kubectl apply -f bookinfo/gateway-api/bookinfo-gateway.yaml"
kubectl apply -f bookinfo/gateway-api/bookinfo-gateway.yaml
echo "--------------------"
sleep 1
echo "kubectl apply -f bookinfo/platform/kube/bookinfo-versions.yaml"
kubectl apply -f bookinfo/platform/kube/bookinfo-versions.yaml
echo "--------------------"
sleep 1
echo "kubectl apply -f bookinfo/gateway-api/route-all-v1.yaml"
kubectl apply -f bookinfo/gateway-api/route-all-v1.yaml
echo "--------------------"
sleep 1
echo "kubectl apply -f bookinfo/gateway-api/route-reviews-90-10.yaml"
kubectl apply -f bookinfo/gateway-api/route-reviews-90-10.yaml
echo "--------------------"
sleep 1
echo "kubectl apply -f bookinfo/gateway-api/route-jason-v2.yaml"
kubectl apply -f bookinfo/gateway-api/route-jason-v2.yaml
echo "--------------------"
sleep 1
echo "bookinfo/platform/kube/cleanup.sh"
bookinfo/platform/kube/cleanup.sh
