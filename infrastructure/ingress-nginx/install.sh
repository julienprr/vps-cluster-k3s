helm install ingress-nginx ingress-nginx/ingress-nginx \
  --version 4.10.0 \
  --namespace ingress-nginx --create-namespace \
  --set controller.publishService.enabled=true
