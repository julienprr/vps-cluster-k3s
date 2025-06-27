set -e

echo "Création du namespace 'logging'..."
kubectl apply -f infrastructure/namespaces/logging.yaml

echo "Déploiement du certificat TLS pour kibana.julienprr.com..."
kubectl apply -f apps/elk/certificate.yaml

echo "Déploiement de l'ingress Kibana..."
kubectl apply -f apps/elk/ingress-kibana.yaml

echo "Installation d'Elasticsearch via Helm..."
helm upgrade --install elasticsearch elastic/elasticsearch \
  -n logging \
  -f apps/elk/elasticsearch-values.yaml

echo "Installation de Kibana via Helm..."
helm upgrade --install kibana elastic/kibana \
  -n logging \
  -f apps/elk/kibana-values.yaml

echo "Installation de Filebeat via Helm..."
helm upgrade --install filebeat elastic/filebeat \
  -n logging \
  -f apps/elk/filebeat-values.yaml

echo "Stack ELK déployée avec succès dans l'environnement PROD."
