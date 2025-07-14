#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$(cd "$SCRIPT_DIR/../../apps/elk/logstash" && pwd)"

echo "[LOGSTASH] Installation de Logstash via Helm..."
helm upgrade --install logstash "$APP_DIR" -n logging -f "$APP_DIR/values.yaml"

echo "[LOGSTASH] Logstash déployé avec succès."
