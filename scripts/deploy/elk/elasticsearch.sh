#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[ELASTICSEARCH] Installation d'Elasticsearch via Helm..."
helm upgrade --install elasticsearch $SCRIPT_DIR/../../apps/elk/elasticsearch -n logging -f apps/elk/elasticsearch/values.yaml

echo "[ELASTICSEARCH] Elasticsearch déployé avec succès."
