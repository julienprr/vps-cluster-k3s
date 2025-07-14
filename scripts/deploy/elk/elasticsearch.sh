#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$(cd "$SCRIPT_DIR/../../apps/elk/elasticsearch" && pwd)"

echo "[ELASTICSEARCH] Installation d'Elasticsearch via Helm..."
helm upgrade --install elasticsearch "$APP_DIR" -n logging -f "$APP_DIR/values.yaml"

echo "[ELASTICSEARCH] Elasticsearch déployé avec succès."
