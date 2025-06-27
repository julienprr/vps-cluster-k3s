### DEPLOYMENT SCRIPT: PORTFOLIO PROD ###
echo "[PORTFOLIO PROD] Création du namespace 'portfolio'..."
kubectl apply -f ../../../infrastructure/namespaces/prod.yaml

echo "[PORTFOLIO PROD] Déploiement du certificat TLS..."
kubectl apply -f ../../apps/portfolio/prod/certificate.yaml

echo "[PORTFOLIO PROD] Déploiement de l'ingress..."
kubectl apply -f ../../apps/portfolio/prod/ingress.yaml

echo "[PORTFOLIO PROD] Déploiement des ressources Kubernetes..."
kubectl apply -f ../../apps/portfolio/prod/

echo "[PORTFOLIO PROD] Déploiement terminé."
