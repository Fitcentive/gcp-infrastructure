#!/bin/bash

# Note - Might need to re-apply nginx controller to enable load balancing via static IP

echo "y" | gcloud container clusters resize fitcentive-dev-gke --node-pool fitcentive-dev-gke --zone northamerica-northeast2-a --num-nodes 1
gcloud sql instances patch gke-dev-env-cloud-sql-instance --activation-policy=ALWAYS