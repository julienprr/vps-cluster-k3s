set -e  # stoppe le script en cas d'erreur

echo "🔧 Déploiement de l'Ingress Controller (nginx)..."
./infrastructure/ingress-nginx/install.sh

echo "🚀 Déploiement de l'application portfolio..."
kubectl apply -f apps/portfolio/

echo "✅ Déploiement terminé."
kubectl get pods,svc,ingress -A
