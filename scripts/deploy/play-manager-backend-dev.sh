#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"


### DEPLOYMENT SCRIPT: PLAY MANAGER BACKEND DEV ###
echo "[PLAY MANAGER BACKEND DEV] Création du namespace 'play-manager'..."
kubectl apply -f "$SCRIPT_DIR/../../infrastructure/namespaces/dev.yaml"

echo "[PLAY MANAGER BACKEND DEV] Déploiement du certificat TLS..."
kubectl apply -f "$SCRIPT_DIR/../../apps/play-manager-backend/dev/certificate.yaml"

echo "[PLAY MANAGER BACKEND DEV] Déploiement de l'ingress..."
kubectl apply -f "$SCRIPT_DIR/../../apps/play-manager-backend/dev/ingress.yaml"

echo "[PLAY MANAGER BACKEND DEV] Déploiement des ressources Kubernetes..."
kubectl apply -f "$SCRIPT_DIR/../../apps/play-manager-backend/dev/"

echo "[PLAY MANAGER BACKEND DEV] Déploiement terminé."
