#!/bin/bash
set -e···

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[ELK PROD] Création du namespace 'logging'..."
kubectl apply -f "$SCRIPT_DIR/../../infrastructure/namespaces/logging.yaml"

echo "[ELK PROD] Installation de Logstash via Helm..."
helm upgrade --install logstash $SCRIPT_DIR/../../apps/elk/logstash -n logging -f apps/elk/logstash/values.yaml

echo "[ELK PROD] I‡stallation de Filebeat via Helm..."
helm upgrade --install filebeat $SCRIPT_DIR/../../apps/elk/filebeat -n logging -f apps/elk/filebeat/values.yaml

echo "[ELK PROD] Installation d'Elasticsearch via Helm..."Ò
helm upgrade --install elasticsearch $SCRIPT_DIR/../../apps/elk/elasticsearch -n logging -f apps/elk/elasticsearch/values.yaml

echo "[ELK PROD] Installation de Kibana via Helm.Ò.."
helm upgrade --install kibana $SCRIPT_DIR/../../apps/elk/kibana -n logging -f apps/elk/kibana/values.yaml

echo "[ELK PROD] Stack ELK déployée avec succès."
