#!/bin/bash

# Note - Consider destroying nginx controller to save resources when nodepool is scaled down

echo "y" | gcloud container clusters resize fitcentive-dev-gke --node-pool fitcentive-dev-gke --zone northamerica-northeast2-a --num-nodes 0
gcloud sql instances patch gke-dev-env-cloud-sql-instance --activation-policy=NEVER