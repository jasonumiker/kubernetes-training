kubectl config set-context docker-desktop-jane --cluster=docker-desktop --namespace=team1 --user=jane
kubectl config set-context docker-desktop-john --cluster=docker-desktop --namespace=team2 --user=john
cat <<EOF >> ~/.kube/config
- name: jane
  user:
    token: SnVWZVFIS3oxcUhZUDdoRE9GaVlNam9pais2Tk1iQ3JUZndrT2RKYXhnQT0K
- name: john
  user:
    token: Y1JLVDU1eFdCVFhBUTY5NnJ0Y04ydkt2dzlvQkgvRlU2R3U1S2tnZmZQMD0K
EOF