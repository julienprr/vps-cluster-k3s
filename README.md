# vps-cluster-k3s

## Architecture

```
vps-cluster-k3s
├─ README.md
├─ apps
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
├─ cert-manager
│  ├─ cluster-issuer-production.yaml
│  └─ cluster-issuer-staging.yaml
└─ infrastructure
   └─ namespaces.yaml

```
