#!/bin/bash
set -e

### DEPLOYMENT SCRIPT: PLAY MANAGER BACKEND PROD ###
echo "[PLAY MANAGER BACKEND PROD] Création du namespace 'play-manager'..."
kubectl apply -f ../../infrastructure/namespaces/prod.yaml

echo "[PLAY MANAGER BACKEND PROD] Déploiement du certificat TLS..."
kubectl apply -f ../../apps/play-manager/backend/prod/certificate.yaml

echo "[PLAY MANAGER BACKEND PROD] Déploiement de l'ingress..."
kubectl apply -f ../../apps/play-manager/backend/prod/ingress.yaml

echo "[PLAY MANAGER BACKEND PROD] Déploiement des ressources Kubernetes..."
kubectl apply -f ../../apps/play-manager/backend/prod/

echo "[PLAY MANAGER BACKEND PROD] Déploiement terminé."
