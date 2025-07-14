#!/bin/bash
set -e

APP_DIR="$(realpath "$(dirname "$0")/../../../apps/elk/filebeat")"

echo "[FILEBEAT] Installation de Filebeat via Helm..."
helm upgrade --install filebeat "$APP_DIR" -n logging -f "$APP_DIR/values.yaml"

echo "[FILEBEAT] Filebeat déployé avec succès."
