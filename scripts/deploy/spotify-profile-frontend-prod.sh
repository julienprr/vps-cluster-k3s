#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

### DEPLOYMENT SCRIPT: SPOTIFY PROFILE FRONTEND PROD ###
echo "[SPOTIFY PROFILE FRONTEND PROD] Création du namespace 'spotify-profile'..."
kubectl apply -f "$SCRIPT_DIR/../../infrastructure/namespaces/prod.yaml"

echo "[SPOTIFY PROFILE FRONTEND PROD] Déploiement du certificat TLS..."
kubectl apply -f "$SCRIPT_DIR/../../apps/spotify-profile-frontend/prod/certificate.yaml"

echo "[SPOTIFY PROFILE FRONTEND PROD] Déploiement de l'ingress..."
kubectl apply -f "$SCRIPT_DIR/../../apps/spotify-profile-frontend/prod/ingress.yaml"

echo "[SPOTIFY PROFILE FRONTEND PROD] Déploiement des ressources Kubernetes..."
kubectl apply -f "$SCRIPT_DIR/../../apps/spotify-profile-frontend/prod/"

echo "[SPOTIFY PROFILE FRONTEND PROD] Déploiement terminé."
