# vps-cluster-k3s

## Architecture

```
vps-cluster-k3s
├─ Makefile
├─ README.md
├─ apps
│  ├─ elk
│  │  ├─ README.md
│  │  ├─ certificate.yaml
│  │  ├─ elasticsearch-values.yaml
│  │  ├─ filebeat-values.yaml
│  │  ├─ ingress-kibana.yaml
│  │  └─ kibana-values.yaml
│  ├─ play-manager-backend
│  │  ├─ dev
│  │  │  ├─ certificate.yaml
│  │  │  ├─ configMap.yaml
│  │  │  ├─ deployment.yaml
│  │  │  ├─ ingress.yaml
│  │  │  ├─ secrets.yaml
│  │  │  └─ service.yaml
│  │  └─ prod
│  │     ├─ certificate.yaml
│  │     ├─ configMap.yaml
│  │     ├─ deployment.yaml
│  │     ├─ ingress.yaml
│  │     ├─ secrets.yaml
│  │     └─ service.yaml
│  ├─ portfolio
│  │  ├─ dev
│  │  │  ├─ certificate.yaml
│  │  │  ├─ deployment.yaml
│  │  │  ├─ ingress.yaml
│  │  │  └─ service.yaml
│  │  └─ prod
│  │     ├─ certificate.yaml
│  │     ├─ deployment.yaml
│  │     ├─ ingress.yaml
│  │     └─ service.yaml
│  └─ spotify-profile-frontend
│     ├─ dev
│     │  ├─ certificate.yaml
│     │  ├─ deployment.yaml
│     │  ├─ ingress.yaml
│     │  └─ service.yaml
│     └─ prod
│        ├─ certificate.yaml
│        ├─ deployment.yaml
│        ├─ ingress.yaml
│        └─ service.yaml
├─ infrastructure
│  ├─ cluster-issuer
│  │  ├─ cluster-issuer-production.yaml
│  │  └─ cluster-issuer-staging.yaml
│  └─ namespaces
│     ├─ dev.yaml
│     ├─ logging.yaml
│     └─ prod.yaml
└─ scripts
   ├─ delete
   ├─ deploy
   │  ├─ elk-prod.sh
   │  ├─ play-manager-backend-dev.sh
   │  ├─ play-manager-backend-prod.sh
   │  ├─ portfolio-dev.sh
   │  ├─ portfolio-prod.sh
   │  ├─ spotify-profile-frontend-dev.sh
   │  └─ spotify-profile-frontend-prod.sh
   └─ init
      └─ add-helm-repos.sh
```

## Déploiement des Sealed Secrets

### 1. Installer le contrôleur Sealed Secrets dans le cluster

```bash
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm repo update
helm install sealed-secrets-controller sealed-secrets/sealed-secrets \
  --namespace kube-system
```

### 2. Récupérer la clé publique du contrôleur

```bash
kubeseal --controller-name=sealed-secrets-controller --controller-namespace=kube-system --fetch-cert > pub-cert.pem
```

### 3. Créer un Secret Kubernetes en clair (localement)

```bash
kubectl create secret generic kibana-secret \
  --from-literal=xpack.encryptedSavedObjects.encryptionKey='changemechangemechangemechangeme' \
  --dry-run=client -o json > kibana-secret.json
```

### 4. Générer un SealedSecret

```bash
kubeseal --cert pub-cert.pem --format yaml < kibana-secret.json > kibana-sealedsecret.yaml
```

Le fichier `kibana-sealedsecret.yaml` peut maintenant être versionné dans le dossier `apps/elk/prod/`.

### 5. Appliquer le SealedSecret dans le cluster

```bash
kubectl apply -f apps/elk/prod/kibana-sealedsecret.yaml
```

Cela créera automatiquement un `Secret` utilisable par Kibana dans le namespace `logging`.

> 💡 Pour créer d'autres SealedSecrets, répétez simplement les étapes 3 à 5 avec les données appropriées.

