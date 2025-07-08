### DEPLOYMENT SCRIPT: SPOTIFY PROFILE FRONTEND DEV ###
echo "[SPOTIFY PROFILE FRONTEND DEV] Création du namespace 'spotify-profile'..."
kubectl apply -f ../../infrastructure/namespaces/dev.yaml

echo "[SPOTIFY PROFILE FRONTEND DEV] Déploiement du certificat TLS..."
kubectl apply -f ../../apps/spotify-profile/frontend/dev/certificate.yaml

echo "[SPOTIFY PROFILE FRONTEND DEV] Déploiement de l'ingress..."
kubectl apply -f ../../apps/spotify-profile/frontend/dev/ingress.yaml

echo "[SPOTIFY PROFILE FRONTEND DEV] Déploiement des ressources Kubernetes..."
kubectl apply -f ../../apps/spotify-profile/frontend/dev/

echo "[SPOTIFY PROFILE FRONTEND DEV] Déploiement terminé."
