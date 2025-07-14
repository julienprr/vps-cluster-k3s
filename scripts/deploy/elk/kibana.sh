#!/bin/bash
set -e

APP_DIR="$(realpath "$(dirname "$0")/../../../apps/elk/kibana")"

echo "[KIBANA] Installation de Kibana via Helm..."
helm upgrade --install kibana "$APP_DIR" -n logging -f "$APP_DIR/values.yaml"

echo "[KIBANA] Stack ELK déployé avec succès."
