#!/usr/bin/env bash
#
# Génère le SealedSecret des Restaurateurs.
#
# Les valeurs en clair ne quittent jamais ta machine : kubeseal les chiffre
# avec la clé publique du cluster, et seul le cluster peut les déchiffrer. Le
# fichier produit peut donc être commité sans risque.
#
# Prérequis : kubeseal installé, kubectl pointant sur le cluster.
#
set -euo pipefail

RACINE="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SORTIE="$RACINE/apps/restaurateurs/prod/sealed-secrets.yaml"

echo "Identifiants de la base (le mot de passe sera aussi celui de Postgres)"
read -rp "  DB_USER [resto] : " DB_USER
DB_USER="${DB_USER:-resto}"
read -rsp "  DB_PASSWORD (laisse vide pour en générer un) : " DB_PASSWORD; echo
if [[ -z "$DB_PASSWORD" ]]; then
  DB_PASSWORD="$(openssl rand -base64 32 | tr -d '/+=' | cut -c1-32)"
  echo "  -> mot de passe généré, conserve-le : $DB_PASSWORD"
fi

echo
echo "Relais SMTP Brevo (SMTP & API -> Créer une clé SMTP)"
read -rp "  SMTP_USER (ex. 9xxxxx001@smtp-brevo.com) : " SMTP_USER
read -rsp "  SMTP_PASSWORD : " SMTP_PASSWORD; echo
read -rp "  MAIL_FROM (ex. Les Restaurateurs <bonjour@ton-domaine.fr>) : " MAIL_FROM

kubectl -n prod create secret generic restaurateurs-secrets \
  --from-literal=DB_USER="$DB_USER" \
  --from-literal=DB_PASSWORD="$DB_PASSWORD" \
  --from-literal=SMTP_USER="$SMTP_USER" \
  --from-literal=SMTP_PASSWORD="$SMTP_PASSWORD" \
  --from-literal=MAIL_FROM="$MAIL_FROM" \
  --dry-run=client -o yaml \
  | kubeseal --format yaml > "$SORTIE"

echo
echo "SealedSecret écrit dans $SORTIE"
echo "Il est chiffré : tu peux le commiter."
echo
echo "Pour l'appliquer :  kubectl apply -f $SORTIE"
