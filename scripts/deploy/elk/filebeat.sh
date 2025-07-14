#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[FILEBEAT] Installation de Filebeat via Helm..."
helm upgrade --install filebeat $SCRIPT_DIR/../../apps/elk/filebeat -n logging -f apps/elk/filebeat/values.yaml

echo "[FILEBEAT] Filebeat déployé avec succès."
