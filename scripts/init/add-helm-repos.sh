set -euo pipefail

echo "Ajout des dépôts Helm requis..."

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add elastic https://helm.elastic.co
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets

echo "Dépôts Helm ajoutés avec succès."

echo "Mise à jour des index..."
helm repo update

helm upgrade --install sealed-secrets sealed-secrets/sealed-secrets \
  --namespace kube-system

echo "Repos Helm mis à jour."
