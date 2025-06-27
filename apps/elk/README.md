# Stack ELK - Environnement de production

Ce dossier contient les fichiers nécessaires au déploiement de la stack **ELK (Elasticsearch, Logstash, Kibana)** avec **Filebeat** pour centraliser et visualiser les logs de tous les pods du cluster K3s.

## 📦 Composants déployés

- **Elasticsearch** : moteur de stockage et de recherche des logs
- **Kibana** : interface de visualisation des logs
- **Filebeat** : agent léger en DaemonSet qui collecte les logs des pods
- **Ingress + certificat TLS** pour exposer Kibana publiquement via HTTPS

## 🗂️ Structure

```
prod/
├── certificate.yaml            # Demande de certificat TLS via cert-manager
├── elasticsearch-values.yaml   # Paramètres Helm pour Elasticsearch
├── filebeat-values.yaml        # Paramètres Helm pour Filebeat
├── ingress-kibana.yaml         # Ingress vers Kibana avec TLS
├── install-elk-prod.sh         # Script de déploiement complet
├── kibana-values.yaml          # Paramètres Helm pour Kibana
└── namespace.yaml              # Namespace ‘logging’
```

## 🚀 Déploiement

Avant tout, assure-toi que :

- Le **ClusterIssuer `letsencrypt-prod`** existe (`cert-manager` installé et configuré)
- Le **repo Helm Elastic** est ajouté :
  ```bash
  helm repo add elastic https://helm.elastic.co
  helm repo update

## 🛠️ Lancer l’installation
chmod +x install-elk-prod.sh
./install-elk-prod.sh

Ce script :
	1.	Crée le namespace logging
	2.	Déploie le certificat TLS pour Kibana
	3.	Applique l’ingress
	4.	Installe Elasticsearch, Kibana et Filebeat avec Helm

🌍 Accès à Kibana

Une fois le certificat émis et l’Ingress actif :

➡️ Accède à Kibana via https://kibana.julienprr.com

📊 Utilisation dans Kibana
	1.	Va dans Discover
	2.	Configure un index pattern : filebeat-*
	3.	Explore les logs en filtrant par pod, conteneur, namespace, etc.

🧩 À améliorer plus tard
	•	Ajout d’alertes dans Kibana
	•	Intégration avec d’autres apps (APM, audit, sécurité)
	•	Externalisation des données Elasticsearch si besoin de persistance longue

⸻

Mainteneur : julienprr
