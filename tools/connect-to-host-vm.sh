docker run -it --rm --privileged --pid=host mirror.gcr.io/debian:12.10 nsenter -t 1 -m -u -n -i