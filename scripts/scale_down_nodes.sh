#!/bin/bash

echo "y" | gcloud container clusters resize fitcentive-dev-gke --node-pool fitcentive-dev-gke --zone northamerica-northeast2-a --num-nodes 0