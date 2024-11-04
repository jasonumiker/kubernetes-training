# Kubernetes Training

This set of general Kubernetes training materials was designed to run on the Kubernetes that is part of Docker Desktop on a Mac or Windows machine. It should actually run on *any* Kubernetes - but it hasn't been documented/tested outside of Docker Desktop.

## Prerequisites
1. Download and Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
1. Open Settings (the gear icon in the upper right) and then enable Kubernetes ![](images/enable_kubernetes.png)
    1. Note that if you ever 'mess up' this cluster you can just click that red Reset Kubernetes Cluster and it'll quickly go back to default settings - it's your 'get out of jail free card'!
1. Install [k9s](https://k9scli.io/)
    1. On Mac you can do this via Homebrew with a `brew install derailed/k9s/k9s`
1. Install git (if it's not already)
    1. On Mac it should already be there if you have installed XCode and/or its Command Line Tools (which are a prerequisite for Homebrew)
1. Run `git clone https://github.com/jasonumiker/kubernetes-training.git`
1. Make sure your kubeconfig is pointed at docker-desktop:
    1. Run `echo $KUBECONFIG` - you should see `~/.kube/config`
        1. If you don't then run `export KUBECONFIG=~/.kube/config` which will point you there for the remainder of this Terminal session
    1. Then run `kubectl config get-contexts` and you should see
        ```
        CURRENT   NAME             CLUSTER          AUTHINFO         NAMESPACE
        *         docker-desktop   docker-desktop   docker-desktop   

        ```

TODO: Add Windows instructions

## Pods, Probes, Services, ReplicaSets and Deployments
In this section you'll learn about:
* [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) - including how Kubernetes ensures they are healthy and ready for traffic via [Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
* [Services](https://kubernetes.io/docs/concepts/services-networking/service/) - whihc is how to expose them outside your cluster and load-balance them
* [ReplicaSets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/) - which is how to scale them out as many 'replica' Pods as you need as well as scale them back in when you no longer need as many
* [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) - which is how we deploy new version/tags of our apps via a new ReplicaSet alongside the existing one and gradually scale it out and the old version down until you're 100% on the new version

### A Pod
Have a look at the PodSpec at [probetest-app/probe-test-app-pod.yaml](https://github.com/jasonumiker/kubernetes-training/blob/main/probe-test-app/probe-test-app-pod.yaml). You'll see the following:
```
apiVersion: v1 #Everything in K8s has to set an explicit apiVersion
kind: Pod #It is a Pod we're creating
metadata:
  name: probe-test-app #Each object has a name
  labels: #But also usually Labels (key:value like AWS Tags)
    app.kubernetes.io/name: probe-test-app #See below re: the common label(s)
spec:
  containers: #We want one or more containers
  - name: probe-test-app #In this case just the one - probe-test-app
    image: jasonumiker/probe-test-app:v1 #With this image:tag
    ports:
    - containerPort: 8080 #On port 8080
    resources:
      requests:
        cpu: 50m #Which needs at least 5% of one core CPU (50/1000)
        memory: 52Mi #And 52 Megabytes of RAM
```
On the subject of labels, the name can't be used in a Label selector for things like Services (which you'll see next). So, we need a label for it as well. It was common to use the 'app' label but recenlty Kubernetes has formalised these into a series of app.kubernetes.io/ labels as described [here](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/).

And we'll look more closely at the Probes in a moment. And a bit more on CPU/Memory Requests and Limits later on as well.

Let's launch this Pod:
* cd into probe-test-app
* Run `kubectl apply -f probe-test-app-pod.yaml`
* Run `kubectl get pods -o wide` - note that you can't get to the Pod's IP which is an overlay network without going through the Node (a local Linux VM running Docker and Kubernetes) or the K8s API

Kubernetes will let us tunnel right to the Pod IP by forwarding a port on our host machine through to it though:
`kubectl port-forward pod/probe-test-app 8080:8080`

Then open http://localhost:8080 in your browser and you'll see the app served by this Pod.

NOTE: You are tunneling *through* the Kubernetes control plane to the Pod. So even if you can't reach the Pod directly (such as in a production environment where a firewall actively prevents it) if you can reach the K8s control plane, and it allows you to port-forward, then you can reach it that way using its access/connectivity to it.

Once you're done you can ctrl-c out of that port-forward in your terminal.

If you wanted to get an interactive shell within the Pod you can do that via the control plane as well:
* `kubectl exec -it probe-test-app -- /bin/bash` - open an interactive bash shell within the pod probe-test-app
* `whoami` - this container is running as the user python
* `ps aux` - I can only see the processes within the container's Linux Namespace
* `exit` - exit back to our Terminal

### A Service
But normally we don't want to go directly to individual Pods. We want a load balancer - and one that bridges the wider corporate network or Internet and our cluster's network in a controlled way.

Kubernetes has a built-in layer 4 loadbalancer in Services.

Let's have a look at an example of a Service at [probe-test-app/probe-test-app-service.yaml](https://github.com/jasonumiker/kubernetes-training/blob/main/probe-test-app/probe-test-app-service.yaml)
```
apiVersion: v1
kind: Service
metadata:
  name: probe-test-app
spec:
  ports:
  - name: 8080-tcp #We want to take traffic in on 8080
    port: 8080
    protocol: TCP
    targetPort: 8080 #And our target Pod(s) are listening on 8080 too
  selector:
    app.kubernetes.io/name: probe-test-app #And our target Pods have this label
  type: LoadBalancer #More about the various types below
  ```
There are several types of services:
* ClusterIP - given an IP that is only reachable by Pods within the Cluster
* NodePort - this assigns a port on each and every Node in the cluster that will route through to this Pod (even if it isn't on the Node)
* LoadBalancer - this sets up a LoadBalancer external to Kuberenetes to front this service (e.g. AWS NLB)

In the case of Docker Desktop they've mapped the LoadBalancer Service type to your laptop's localhost for convenience.

Deploy the service by running `kubectl apply -f probe-test-app-service.yaml`

You can see the details by running `kubectl get services -o wide`. You'll see that:
* The probe-test-app service is of a LoadBalancer type 
* With an EXTERNAL-IP (usually the DNS address of the external load balancer you should be able to reach it on) of localhost 
* And that it is actually mapping port 8080 on the LoadBalancer through a random NodePort in the 30000-ish range on its way in.
    * You can just ignore that and use the http://localhost:8080 and ignore that though - thanks Docker Desktop!
* That it is pointing at any Pods (it's Selector) with the label `app.kubernetes.io/name=probe-test-app`

If you run `kubectl get endpoints` you'll see the Pod IP there as the only endpoint of the service (you can see the Pod IP to verify it is what you see with `kubectl get pods -o wide`).

To see that in action we can add a 2nd Pod with that label by running `kubectl apply -f probe-test-app-pod-2.yaml`

If you re-run `kubectl get endpoints` you'll now see the 2nd Pod has been added as an endpoint for the serivce.

And if you go to http://localhost:8080 in your browser and refresh you'll see that the name changes in what Pod that you're served from (that you are balanced between them). Note that the hostname the Pod sees is its Pod name - and I am just returning that hostname here.

