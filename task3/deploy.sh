#! /bin/sh

# Docker build
# replace with your docker repository
docker build -t allthatjazzleo/fsdfqwefwxcsd:latest . 
docker push allthatjazzleo/fsdfqwefwxcsd:latest  

# Deploy to K8S 
kubectl apply -f ./kubernetes-manifests/url-shortener-deployment.yaml
kubectl apply -f ./kubernetes-manifests/url-shortener-service.yaml

# Apply Horizontal Pod Autoscaler rule to API pod
kubectl autoscale deployment url-shortener --cpu-percent=80 --min=1 --max=10
