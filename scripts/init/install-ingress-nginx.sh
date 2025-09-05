
echo "Installation de l'ingress-nginx..."

kubectl create namespace ingress-nginx || true
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --version 4.10.0 \
  --set controller.ingressClassResource.name=nginx \
  --set controller.ingressClassResource.enabled=true \
  --set controller.ingressClassResource.default=true \
  --set controller.service.type=LoadBalancer

echo "Ingress NGINX installé avec succès."
