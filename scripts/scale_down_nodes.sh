#!/bin/bash

# Note - Consider destroying nginx controller to save resources when nodepool is scaled down

echo "y" | gcloud container clusters resize fitcentive-dev-03-gke --node-pool fitcentive-dev-03-gke --zone northamerica-northeast2-a --num-nodes 0
# gcloud sql instances patch gke-dev-env-cloud-sql-instance --activation-policy=NEVER