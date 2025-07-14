#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$(cd "$SCRIPT_DIR/../../apps/elk/kibana" && pwd)"

echo "[KIBANA] Installation de Kibana via Helm..."
helm upgrade --install kibana "$APP_DIR" -n logging -f "$APP_DIR/values.yaml"

echo "[KIBANA] Stack ELK déployé avec succès."
