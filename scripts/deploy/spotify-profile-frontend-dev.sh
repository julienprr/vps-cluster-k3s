#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

### DEPLOYMENT SCRIPT: SPOTIFY PROFILE FRONTEND DEV ###
echo "[SPOTIFY PROFILE FRONTEND DEV] Création du namespace 'spotify-profile'..."
kubectl apply -f "$SCRIPT_DIR/../../infrastructure/namespaces/dev.yaml"

echo "[SPOTIFY PROFILE FRONTEND DEV] Déploiement du certificat TLS..."
kubectl apply -f "$SCRIPT_DIR/../../apps/spotify-profile-frontend/dev/certificate.yaml"

echo "[SPOTIFY PROFILE FRONTEND DEV] Déploiement de l'ingress..."
kubectl apply -f "$SCRIPT_DIR/../../apps/spotify-profile-frontend/dev/ingress.yaml"

echo "[SPOTIFY PROFILE FRONTEND DEV] Déploiement des ressources Kubernetes..."
kubectl apply -f "$SCRIPT_DIR/../../apps/spotify-profile-frontend/dev/"

echo "[SPOTIFY PROFILE FRONTEND DEV] Déploiement terminé."
