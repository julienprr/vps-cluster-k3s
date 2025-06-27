# Variables
SHELL := /bin/bash

# Par défaut
.DEFAULT_GOAL := help

# =======================
# INFRASTRUCTURE
# =======================

init:
	bash scripts/init/add-helm-repos.sh


namespaces:
	kubectl apply -f infrastructure/namespaces/

infra: init namespaces

# =======================
# ENVIRONNEMENT DEV
# =======================

deploy-dev:
	bash scripts/deploy/portfolio-dev.sh
	bash scripts/deploy/play-manager-backend-dev.sh
	bash scripts/deploy/spotify-profile-frontend-dev.sh

# =======================
# ENVIRONNEMENT PROD
# =======================

deploy-prod:
	bash scripts/deploy/portfolio-prod.sh
	bash scripts/deploy/play-manager-backend-prod.sh
	bash scripts/deploy/spotify-profile-frontend-prod.sh

# =======================
# LOGGING / ELK
# =======================

deploy-elk: kibana-secret
	bash scripts/deploy/elk-prod.sh

kibana-secret:
	kubectl apply -f apps/elk/kibana-sealed-secret.yaml

# =======================
# AIDE
# =======================

help:
	@echo "Commandes disponibles :"
	@echo "  make init              → Ajouter les dépôts Helm"
	@echo "  make ingress-classes   → Déployer les ingress classes (nginx, etc.)"
	@echo "  make namespaces        → Créer les namespaces"
	@echo "  make infra             → Tout ce qui précède"
	@echo "  make deploy-dev        → Déployer toutes les apps en environnement DEV"
	@echo "  make deploy-prod       → Déployer toutes les apps en environnement PROD"
	@echo "  make deploy-elk        → Déployer l'infrastructure ELK (en PROD)"
