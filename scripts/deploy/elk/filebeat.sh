#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$(cd "$SCRIPT_DIR/../../apps/elk/filebeat" && pwd)"

echo "[FILEBEAT] Installation de Filebeat via Helm..."
helm upgrade --install filebeat "$APP_DIR" -n logging -f "$APP_DIR/values.yaml"

echo "[FILEBEAT] Filebeat déployé avec succès."
