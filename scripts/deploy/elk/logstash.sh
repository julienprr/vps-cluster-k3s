#!/bin/bash
set -e

APP_DIR="$(realpath "$(dirname "$0")/../../../apps/elk/logstash")"

echo "[LOGSTASH] Installation de Logstash via Helm..."
helm upgrade --install logstash "$APP_DIR" -n logging -f "$APP_DIR/values.yaml"

echo "[LOGSTASH] Logstash déployé avec succès."
