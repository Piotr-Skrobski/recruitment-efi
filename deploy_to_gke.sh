#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: ./deploy_to_gke.sh PROJECT_ID ZONE"
    echo "Please provide the Google Cloud project ID and zone."
    echo "You can find available zones here: https://cloud.google.com/compute/docs/regions-zones"
    exit 1
fi

PROJECT_ID=$1
ZONE=$2

docker-compose up -d

docker tag weatherapp_frontend:latest gcr.io/$PROJECT_ID/weatherapp_frontend:latest
docker tag weatherapp_backend:latest gcr.io/$PROJECT_ID/weatherapp_backend:latest

docker push gcr.io/$PROJECT_ID/weatherapp_frontend:latest
docker push gcr.io/$PROJECT_ID/weatherapp_backend:latest

gcloud container clusters create my-cluster --num-nodes=3 --zone=$ZONE

