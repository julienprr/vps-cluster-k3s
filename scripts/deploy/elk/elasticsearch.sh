#!/bin/bash
set -e

APP_DIR="$(realpath "$(dirname "$0")/../../../apps/elk/elasticsearch")"

echo "[ELASTICSEARCH] Installation d'Elasticsearch via Helm..."
helm upgrade --install elasticsearch "$APP_DIR" -n logging -f "$APP_DIR/values.yaml"

echo "[ELASTICSEARCH] Elasticsearch déployé avec succès."
