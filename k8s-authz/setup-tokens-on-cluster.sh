#!/usr/bin/env bash
docker run -it --privileged --pid=host debian:12.8 nsenter -t 1 -m -u -n -i \
    sh -c "sed -i '/    - --watch-cache=false/a\    - --token-auth-file=/run/config/pki/known_tokens.csv' /etc/kubernetes/manifests/kube-apiserver.yaml"
docker run -it --privileged --pid=host debian:12.8 nsenter -t 1 -m -u -n -i \
    sh -c "echo SnVWZVFIS3oxcUhZUDdoRE9GaVlNam9pais2Tk1iQ3JUZndrT2RKYXhnQT0K,jane,jane > /run/config/pki/known_tokens.csv"
docker run -it --privileged --pid=host debian:12.8 nsenter -t 1 -m -u -n -i \
    sh -c "echo Y1JLVDU1eFdCVFhBUTY5NnJ0Y04ydkt2dzlvQkgvRlU2R3U1S2tnZmZQMD0K,john,john >> /run/config/pki/known_tokens.csv"