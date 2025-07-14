#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[KIBANA] Installation de Kibana via Helm..."
helm upgrade --install kibana $SCRIPT_DIR/../../apps/elk/kibana -n logging -f apps/elk/kibana/values.yaml

echo "[KIBANA] Stack ELK déployé avec succès."
