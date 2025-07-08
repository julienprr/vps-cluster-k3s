#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

### DEPLOYMENT SCRIPT: PORTFOLIO PROD ###
echo "[PORTFOLIO PROD] Création du namespace 'portfolio'..."
kubectl apply -f "$SCRIPT_DIR/../../infrastructure/namespaces/prod.yaml"

echo "[PORTFOLIO PROD] Déploiement du certificat TLS..."
kubectl apply -f "$SCRIPT_DIR/../../apps/portfolio/prod/certificate.yaml"

echo "[PORTFOLIO PROD] Déploiement de l'ingress..."
kubectl apply -f "$SCRIPT_DIR/../../apps/portfolio/prod/ingress.yaml"

echo "[PORTFOLIO PROD] Déploiement des ressources Kubernetes..."
kubectl apply -f "$SCRIPT_DIR/../../apps/portfolio/prod/"

echo "[PORTFOLIO PROD] Déploiement terminé."
