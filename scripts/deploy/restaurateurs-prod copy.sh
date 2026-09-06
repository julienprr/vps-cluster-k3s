#!/usr/bin/env bash
#
# Première mise en place des Restaurateurs en production.
#
# À lancer une seule fois, ou après avoir modifié les manifests. Les mises à
# jour d'image ensuite passent par GitHub Actions, qui ne fait que remplacer
# l'image des Deployments existants.
#
set -euo pipefail

RACINE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOSSIER="$RACINE/apps/restaurateurs/prod"

echo "Contexte kubectl : $(kubectl config current-context)"
read -rp "Déployer les Restaurateurs en production ? [o/N] " reponse
[[ "$reponse" == "o" ]] || { echo "Annulé."; exit 0; }

# Le secret d'abord : Postgres et l'API refusent de démarrer sans lui.
if ! kubectl -n prod get secret restaurateurs-secrets >/dev/null 2>&1; then
  echo
  echo "Le secret restaurateurs-secrets est absent."
  echo "Génère-le d'abord : scripts/deploy/seal-restaurateurs-secrets.sh"
  exit 1
fi

kubectl apply -f "$DOSSIER/configMap.yaml"
kubectl apply -f "$DOSSIER/db-service.yaml"
kubectl apply -f "$DOSSIER/db-statefulset.yaml"
kubectl apply -f "$DOSSIER/db-backup.yaml"

echo "Attente de Postgres..."
kubectl -n prod rollout status statefulset/restaurateurs-db --timeout=180s

kubectl apply -f "$DOSSIER/api-service.yaml"
kubectl apply -f "$DOSSIER/api-deployment.yaml"
kubectl apply -f "$DOSSIER/web-service.yaml"
kubectl apply -f "$DOSSIER/web-deployment.yaml"
kubectl apply -f "$DOSSIER/certificate.yaml"
kubectl apply -f "$DOSSIER/ingress.yaml"

echo "Attente de l'API (migrations Flyway au premier démarrage)..."
kubectl -n prod rollout status deployment/restaurateurs-api --timeout=300s
kubectl -n prod rollout status deployment/restaurateurs-web --timeout=120s

echo
kubectl -n prod get pods,svc,ingress,certificate -l 'app in (restaurateurs-api,restaurateurs-web,restaurateurs-db)' 2>/dev/null || \
  kubectl -n prod get pods | grep restaurateurs
echo
echo "Le certificat peut mettre une minute à être délivré :"
echo "  kubectl -n prod get certificate restaurateurs-tls -w"
