#!/usr/bin/env bash
#I retreieved this from https://gist.github.com/SpoddyCoder/ff0ea39260b0d4acdb8b482532d4c1af on 7/11/24

echo
echo "Updating docker-desktop pods to expose metrics endpoints"
echo "This will involve several kube-system pod restarts" 
echo

echo "Fetching debian image to run nsenter on the docker-desktop host..."
docker pull mirror.gcr.io/debian:12.10

NODE_IP=$(kubectl get nodes -o wide --no-headers | awk -v OFS='\t\t' '{print $6}')
echo "Host Node IP: $NODE_IP"

echo "Updating kube-proxy configmap..."
MOD_YAML="/tmp/modify.yaml"
kubectl get configmap/kube-proxy -n kube-system -o yaml > $MOD_YAML
if cat $MOD_YAML | grep -q "metricsBindAddress: 127.0.0.1:10249"; then
    # sed is different on the mac - cater for that
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/metricsBindAddress: 127.0.0.1:10249/metricsBindAddress: 0.0.0.0:10249/g' $MOD_YAML
    else
        sed -i 's/metricsBindAddress: 127.0.0.1:10249/metricsBindAddress: 0.0.0.0:10249/g' $MOD_YAML
    fi
    kubectl delete configmap/kube-proxy -n kube-system
    kubectl create -f $MOD_YAML
    echo "Restarting the kube-proxy pod"
    kubectl delete pod -n kube-system -l k8s-app=kube-proxy
    if ! kubectl wait -n kube-system --timeout=5m --for=condition=Ready pod -l k8s-app=kube-proxy; then
        echo "kube-proxy pod did not restart in time, please check the pod logs."
        exit 1
    fi
    echo "kube-proxy pod restarted."
else
    echo "kube-proxy metricBindAddress already updated, skipping."
fi
rm -f $MOD_YAML

echo "Updating bind-address on kube-controller-manager..."
if kubectl describe pod kube-controller-manager-docker-desktop -n kube-system | grep -q "bind-address=127.0.0.1"; then
    docker run -it --privileged --pid=host mirror.gcr.io/debian:12.10 nsenter -t 1 -m -u -n -i \
        sh -c "sed -i 's/--bind-address=127.0.0.1/--bind-address=0.0.0.0/g' /etc/kubernetes/manifests/kube-controller-manager.yaml"
    echo "Waiting for kube-controller-manager to restart, this can take some time..."
    kubectl wait pod -l component=kube-controller-manager -n kube-system --timeout=5m --for=delete 
    if ! kubectl wait pod -l component=kube-controller-manager -n kube-system --timeout=5m --for=condition=Ready; then
        echo "kube-controller-manager pod did not restart in time, please check the pod logs."
        exit 1
    fi
    echo "kube-controller-manager pod restarted."
else
    echo "kube-controller-manager bind-address already updated, skipping."
fi

echo "Updating bind-address on kube-scheduler"
if kubectl describe pod kube-scheduler-docker-desktop -n kube-system | grep -q "bind-address=127.0.0.1"; then
    docker run -it --privileged --pid=host mirror.gcr.io/debian:12.10 nsenter -t 1 -m -u -n -i \
        sh -c "sed -i 's/--bind-address=127.0.0.1/--bind-address=0.0.0.0/g' /etc/kubernetes/manifests/kube-scheduler.yaml"
    echo "Waiting for kube-scheduler to restart, this can take some time..."
    kubectl wait pod -l component=kube-scheduler -n kube-system --timeout=5m --for=delete
    if ! kubectl wait pod -l component=kube-scheduler -n kube-system --timeout=5m --for=condition=Ready; then
        echo "kube-scheduler pod did not restart in time, please check the pod logs."
        exit 1
    fi
    echo "kube-scheduler pod restarted."
else
    echo "kube-scheduler bind-address already updated, skipping."
fi

echo "Adding node ip to listen-metrics-urls on etcd"
if kubectl describe pod etcd-docker-desktop -n kube-system | grep "listen-metrics-urls" | grep -q "http://${NODE_IP}:2381"; then
    echo "etcd listen-metrics-urls already updated, skipping."
else
    docker run -it --privileged --pid=host mirror.gcr.io/debian:12.10 nsenter -t 1 -m -u -n -i \
        sh -c "sed -i 's/--listen-metrics-urls=http:\/\/127.0.0.1\:2381/--listen-metrics-urls=http:\/\/127.0.0.1\:2381,http:\/\/${NODE_IP}\:2381/g' /etc/kubernetes/manifests/etcd.yaml"
    echo "Waiting for etcd to restart, this can take some time..."
    kubectl wait pod -l component=etcd -n kube-system --timeout=5m --for=delete                         # as soon as etcd goes down this will respond with an error from the api server
    sleep 20                                                                                            # so we wait for a few seconds for the api server to reboot & then we can run kubectl commands again
    if ! kubectl wait pod -l component=etcd -n kube-system --timeout=5m --for=condition=Ready; then     # if all gone well this should respond immediately
        echo "etcd pod did not restart in time - this may just be the api server still rebooting, give it a few minutes before panicking."
    fi
fi

echo
echo "Done! You can now deploy the monitoring components."
echo