#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: ./deploy_to_gke.sh PROJECT_ID ZONE CLUSTER_NAME"
    echo "Please provide the Google Cloud project ID and zone."
    echo "You can find available zones here: https://cloud.google.com/compute/docs/regions-zones"
    exit 1
fi

PROJECT_ID=$1
ZONE=$2
CLUSTER_NAME=$3

GPG_KEY=$(gpg --list-secret-keys --keyid-format SHORT | awk '/sec/{print $2}' | awk -F'/' '{print $2}')

if [ -z "$GPG_KEY" ]; then
    echo "No GPG key found. Generating a new one..."
    gpg --gen-key  
    GPG_KEY=$(gpg --list-secret-keys --keyid-format SHORT | awk '/sec/{print $2}' | awk -F'/' '{print $2}')
fi

pass init $GPG_KEY

gcloud init
gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://europe-north1-docker.pkg.dev
gcloud auth configure-docker 
gcloud config set project $PROJECT_ID

docker compose up -d

docker tag recruitment-efi-frontend gcr.io/$PROJECT_ID/weatherapp_frontend:latest
docker tag recruitment-efi-frontend gcr.io/$PROJECT_ID/weatherapp_backend:latest

docker push gcr.io/$PROJECT_ID/weatherapp_frontend:latest
docker push gcr.io/$PROJECT_ID/weatherapp_backend:latest

if gcloud container clusters describe $CLUSTER_NAME --zone=$ZONE > /dev/null 2>&1; then
    echo "Cluster $CLUSTER_NAME already exists, skipping creation."
else
    gcloud container clusters create $CLUSTER_NAME --num-nodes=2 --zone=$ZONE
fi

gcloud container clusters get-credentials $CLUSTER_NAME --zone=$ZONE

# For ease of debugging

kubectl delete configmap frontend-config --ignore-not-found
kubectl delete configmap backend-config --ignore-not-found

kubectl delete deployment weatherapp-frontend --ignore-not-found
kubectl delete deployment weatherapp-backend --ignore-not-found

kubectl delete service weatherapp-frontend --ignore-not-found
kubectl delete service backend-service --ignore-not-found

kubectl create configmap frontend-config --from-env-file=./frontend/.env
kubectl create configmap backend-config --from-env-file=./backend/.env.j2

kubectl create deployment weatherapp-frontend --image=gcr.io/$PROJECT_ID/weatherapp_frontend:latest --port=8000
kubectl set env deployment/weatherapp-frontend --from=configmap/frontend-config
kubectl expose deployment weatherapp-frontend --type=LoadBalancer --port 8000 --target-port 8000

kubectl create deployment weatherapp-backend --image=gcr.io/$PROJECT_ID/weatherapp_backend:latest --port=8000
kubectl set env deployment/weatherapp-backend --from=configmap/backend-config
kubectl expose deployment weatherapp-backend --name=backend-service --type=ClusterIP --port=8000 --target-port=8000

kubectl get deployments
kubectl get services