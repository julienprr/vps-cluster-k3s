#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[LOGSTASH] Installation de Logstash via Helm..."
helm upgrade --install logstash $SCRIPT_DIR/../../apps/elk/logstash -n logging -f apps/elk/logstash/values.yaml

echo "[LOGSTASH] Logstash déployé avec succès."
