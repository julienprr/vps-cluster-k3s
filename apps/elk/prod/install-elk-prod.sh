set -e

echo "🔧 Création du namespace 'logging'..."
kubectl apply -f namespace.yaml

echo "📜 Déploiement du certificat TLS pour kibana.julienprr.com..."
kubectl apply -f certificate.yaml

echo "🌐 Déploiement de l'ingress Kibana..."
kubectl apply -f ingress-kibana.yaml

echo "📦 Installation d'Elasticsearch via Helm..."
helm upgrade --install elasticsearch elastic/elasticsearch \
  -n logging \
  -f elasticsearch-values.yaml

echo "📦 Installation de Kibana via Helm..."
helm upgrade --install kibana elastic/kibana \
  -n logging \
  -f kibana-values.yaml

echo "📦 Installation de Filebeat via Helm..."
helm upgrade --install filebeat elastic/filebeat \
  -n logging \
  -f filebeat-values.yaml

echo "✅ Stack ELK déployée avec succès dans l'environnement PROD."
