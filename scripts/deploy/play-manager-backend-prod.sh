#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

### DEPLOYMENT SCRIPT: PLAY MANAGER BACKEND PROD ###
echo "[PLAY MANAGER BACKEND PROD] Création du namespace 'play-manager'..."
kubectl apply -f "$SCRIPT_DIR/../../infrastructure/namespaces/prod.yaml"

echo "[PLAY MANAGER BACKEND PROD] Déploiement du certificat TLS..."
kubectl apply -f "$SCRIPT_DIR/../../apps/play-manager/backend/prod/certificate.yaml"

echo "[PLAY MANAGER BACKEND PROD] Déploiement de l'ingress..."
kubectl apply -f "$SCRIPT_DIR/../../apps/play-manager/backend/prod/ingress.yaml"

echo "[PLAY MANAGER BACKEND PROD] Déploiement des ressources Kubernetes..."
kubectl apply -f "$SCRIPT_DIR/../../apps/play-manager/backend/prod/"

echo "[PLAY MANAGER BACKEND PROD] Déploiement terminé."
