# Kubernetesaudit
Some tools to perform kubernetes-audits, from the perspective of a hacked container running in a kubernetes pod.

If you have access to the kubernetes environment with sufficient priviliges your can just get a shell on the container like this:

```
kubectl get pods
NAME                                          READY   STATUS    RESTARTS   AGE
kubernetesaudit-deployment-1da5e985c3-akafb   1/1     Running   0          32m

kubectl exec -it kubernetesaudit-deployment-1da5e985c3-akafb -- /bin/bash
```

Otherwise you might have to set up a pod which performs a callback with a reverse shell to your internet exposed machine.

## Dockerfile
The dockerfile contains the setup for the docker image. It is just a debian with some useful tools, such as kubectl. And the reverse shell of course. Uncomment the gitrepos if you want those repos as well.
The image is also available here:
https://hub.docker.com/r/xapax/kubernetesaudit

## setuppki.sh
This is just a simple easyrsa-wrapper that creates a CA, server certificate and client certificate. It also creates the file-structure to serve your https-server, and then to receive your incoming client-authenticated reverse shell.

The script should be run on the machine where you want to host your webserver and reverse shell.
It will also create a random token. Used to create a path on the server where client-cert and CA is provided from.
This random token needs to be added to your deploymentspecs_kubernetes.yaml file. Together with your domain as well.

## deploymentspecs_kubernetes.yaml
This is the kubernetes Deployment for creating the Kubernetesaudit image as a kubernetes pod.

It can be deployed in your kubernetes cluster like this:

```
kubectl create -f deploymentspecs_kubernetes.yaml
```


## Credit
The reverse shell and docker image was created by https://github.com/Doctor-love. All credit to Doctor-love! 
