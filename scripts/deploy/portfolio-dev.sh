### DEPLOYMENT SCRIPT: PORTFOLIO DEV ###
echo "[PORTFOLIO DEV] Création du namespace 'portfolio'..."
kubectl apply -f ../../infrastructure/namespaces/dev.yaml

echo "[PORTFOLIO DEV] Déploiement du certificat TLS..."
kubectl apply -f ../../apps/portfolio/dev/certificate.yaml

echo "[PORTFOLIO DEV] Déploiement de l'ingress..."
kubectl apply -f ../../apps/portfolio/dev/ingress.yaml

echo "[PORTFOLIO DEV] Déploiement des ressources Kubernetes..."
kubectl apply -f ../../apps/portfolio/dev/

echo "[PORTFOLIO DEV] Déploiement terminé."
