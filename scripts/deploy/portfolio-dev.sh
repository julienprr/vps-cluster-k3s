#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

### DEPLOYMENT SCRIPT: PORTFOLIO DEV ###
echo "[PORTFOLIO DEV] Création du namespace 'portfolio'..."
kubectl apply -f "$SCRIPT_DIR/../../infrastructure/namespaces/dev.yaml"

echo "[PORTFOLIO DEV] Déploiement du certificat TLS..."
kubectl apply -f "$SCRIPT_DIR/../../apps/portfolio/dev/certificate.yaml"

echo "[PORTFOLIO DEV] Déploiement de l'ingress..."
kubectl apply -f "$SCRIPT_DIR/../../apps/portfolio/dev/ingress.yaml"

echo "[PORTFOLIO DEV] Déploiement des ressources Kubernetes..."
kubectl apply -f "$SCRIPT_DIR/../../apps/portfolio/dev/"

echo "[PORTFOLIO DEV] Déploiement terminé."
