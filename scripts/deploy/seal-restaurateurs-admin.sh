#!/usr/bin/env bash
#
# Génère le SealedSecret du jeton d'administration des Restaurateurs.
#
# Séparé de restaurateurs-secrets pour pouvoir le changer sans retaper les
# mots de passe de la base et de Brevo : Postgres garde celui de sa création,
# une faute de frappe couperait l'API de sa base.
#
# Le jeton protège les routes /api/admin/** (en-tête X-Admin-Token) : clôture
# des sorties à la main, annonce de version.
#
# Prérequis : kubeseal installé, kubectl pointant sur le cluster.
#
set -euo pipefail

RACINE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SORTIE="$RACINE/apps/restaurateurs/prod/sealed-admin-secret.yaml"

ADMIN_TOKEN="$(openssl rand -hex 32)"

kubectl -n prod create secret generic restaurateurs-admin \
  --from-literal=ADMIN_TOKEN="$ADMIN_TOKEN" \
  --dry-run=client -o yaml \
  | kubeseal --controller-name=sealed-secrets --controller-namespace=kube-system --format yaml > "$SORTIE"

echo "Jeton généré. Range-le dans ton gestionnaire de mots de passe :"
echo "il ne sera plus affiché, et le fichier scellé ne permet pas de le relire."
echo
echo "  $ADMIN_TOKEN"
echo
echo "SealedSecret écrit dans $SORTIE"
echo "Il est chiffré : tu peux le commiter."
echo
echo "Pour l'appliquer, AVANT le Deployment de l'API :"
echo "  kubectl apply -f $SORTIE"
