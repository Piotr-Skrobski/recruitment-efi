#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: ./deploy_to_gke.sh PROJECT_ID ZONE"
    echo "Please provide the Google Cloud project ID and zone."
    echo "You can find available zones here: https://cloud.google.com/compute/docs/regions-zones"
    exit 1
fi

PROJECT_ID=$1
ZONE=$2

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

gcloud container clusters create my-cluster --num-nodes=2 --zone=$ZONE
gcloud container clusters get-credentials my-cluster --region=$ZONE