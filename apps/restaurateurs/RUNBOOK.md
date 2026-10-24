# Les Restaurateurs — exploitation

Tout ce qu'il faut pour déployer, diagnostiquer et réparer.

- Production : https://restaurateurs.julienprr.com
- Namespace : `prod`
- Dépôts : `restaurateurs-api`, `restaurateurs-web`, et celui-ci
- Ce dépôt sur le VPS : `/opt/projects/vps-cluster-k3s`

Les commandes ci-dessous utilisent `$VPS` pour l'accès au serveur. Définis-le
une fois par session, il n'a pas sa place dans un dépôt public :

```bash
export VPS=utilisateur@adresse-du-vps
```

## Règle de base

**On modifie depuis le Mac, on applique depuis le VPS.**

| Où | Quoi |
|---|---|
| Mac | éditer, commiter, pousser |
| VPS | `git pull`, puis `kubectl apply` |

Le VPS n'a pas besoin de pouvoir écrire sur GitHub, et c'est mieux ainsi : une
machine exposée sur Internet ne devrait pas pouvoir modifier tes dépôts.

Seule exception : `sealed-secrets.yaml`, qui doit être généré près du cluster.
On le récupère ensuite par `scp`.

## Déployer du code

Rien à faire. Un `git push` sur `main` dans `restaurateurs-api` ou
`restaurateurs-web` lance les tests, construit l'image, met à jour le
Deployment et vérifie que le pod redémarre.

Suivre : onglet Actions du dépôt concerné.

## Déployer un changement de manifest

Sur le Mac :

```bash
cd ~/workspaces/vps/vps-cluster-k3s
# éditer, puis
git add -A && git commit -m "..." && git push
```

Sur le VPS, en tant que `julienprr` et **pas** `root` :

```bash
cd /opt/projects/vps-cluster-k3s
git pull
kubectl apply -f apps/restaurateurs/prod/<le-fichier>.yaml
```

**Si tu as modifié `configMap.yaml`, redémarre l'API.** Les variables
d'environnement sont lues une seule fois, au démarrage du conteneur :

```bash
kubectl -n prod rollout restart deployment/restaurateurs-api
kubectl -n prod rollout status deployment/restaurateurs-api
kubectl -n prod exec deployment/restaurateurs-api -- printenv APP_BASE_URL
```

La dernière ligne vérifie ce que l'API voit réellement. `kubectl apply` qui
répond `unchanged` signifie que ton `git pull` n'a rien ramené.

## Regarder ce qui se passe

```bash
kubectl -n prod get pods | grep restaurateurs
kubectl -n prod logs -f deployment/restaurateurs-api
kubectl -n prod logs deployment/restaurateurs-api --previous   # pod qui a planté
kubectl -n prod describe pod <nom-du-pod>
kubectl -n prod get certificate restaurateurs-tls
```

## Diagnostic

| Symptôme | Cause probable | Vérifier |
|---|---|---|
| Le site ne répond plus | pod arrêté | `kubectl -n prod get pods` |
| `ImagePullBackOff` | image absente de Docker Hub | les tags publiés |
| `CrashLoopBackOff` | démarrage en échec | `logs --previous` |
| Les emails n'arrivent plus | clé Brevo expirée ou révoquée | `logs` pour l'erreur SMTP |
| Lien de connexion qui ne mène nulle part | `APP_BASE_URL` | `exec -- printenv APP_BASE_URL` |
| Les votes n'arrivent pas en direct | mise en tampon de l'Ingress | les annotations `proxy-buffering` |
| Pas de HTTPS | certificat non délivré | `describe certificate restaurateurs-tls` |

### Le temps réel, test rapide

```bash
curl -N -m 5 https://restaurateurs.julienprr.com/api/groups/x/events
```

Un 401 immédiat est bon signe : la réponse traverse sans être accumulée. Si la
commande reste suspendue, les annotations de l'Ingress ont sauté.

## Les secrets

Cinq valeurs dans `restaurateurs-secrets` : `DB_USER`, `DB_PASSWORD`,
`SMTP_USER`, `SMTP_PASSWORD`, `MAIL_FROM`.

Pour en changer une, sur le VPS :

```bash
cd /opt/projects/vps-cluster-k3s
./scripts/deploy/seal-restaurateurs-secrets.sh
kubectl apply -f apps/restaurateurs/prod/sealed-secrets.yaml
kubectl -n prod rollout restart deployment/restaurateurs-api
```

Puis récupérer le fichier scellé sur le Mac pour le versionner :

```bash
scp $VPS:/opt/projects/vps-cluster-k3s/apps/restaurateurs/prod/sealed-secrets.yaml \
    ~/workspaces/vps/vps-cluster-k3s/apps/restaurateurs/prod/
```

Le contrôleur s'appelle `sealed-secrets` dans `kube-system`, d'où les options
`--controller-name` et `--controller-namespace` dans le script.

## Les sauvegardes

Un CronJob tourne chaque nuit à 3 h 30 et conserve 14 jours.

```bash
kubectl -n prod get cronjob restaurateurs-db-backup
kubectl -n prod create job --from=cronjob/restaurateurs-db-backup sauvegarde-manuelle
```

**Elles restent sur le VPS.** Si la machine disparaît, elles disparaissent
aussi. À rapatrier de temps en temps :

```bash
POD=$(kubectl -n prod get pods -l app=restaurateurs-backup -o name | head -1 | cut -d/ -f2)
kubectl -n prod cp "$POD":/backups ./sauvegardes-restaurateurs
```

### Restaurer

```bash
gunzip -c restaurateurs-2026-10-24-0330.sql.gz \
  | kubectl -n prod exec -i statefulset/restaurateurs-db -- \
      sh -c 'psql -U "$POSTGRES_USER" restaurateurs'
```

## Échéances

| Date | Quoi | Conséquence si oublié |
|---|---|---|
| 7 octobre 2027 | la clé SMTP Brevo expire | plus aucun email, donc plus aucune connexion, **sans alerte** |
| automatique | certificat HTTPS | cert-manager renouvelle seul |

## Accès au serveur

**Par clé uniquement**, depuis le 24 octobre 2026. Les mots de passe sont
refusés pour tous les utilisateurs.

Si un jour tu dois vérifier ou modifier la configuration SSH, retiens que
`sshd` applique **la première** valeur rencontrée, pas la dernière, et que les
fichiers de `/etc/ssh/sshd_config.d/` sont lus avant le fichier principal, par
ordre alphabétique. Un `50-cloud-init.conf` l'emporte donc sur un
`60-cloudimg-settings.conf` et sur `sshd_config` lui-même.

La seule source de vérité est la configuration effective :

```bash
sshd -T | grep -i passwordauthentication
```

`ssh_pwauth: false` est posé dans `/etc/cloud/cloud.cfg.d/` pour que cloud-init
ne réactive pas les mots de passe à un redémarrage.

## À ne pas faire

**Ne pas augmenter `replicas` de l'API.** Les connexions temps réel vivent en
mémoire : avec deux répliques, un membre connecté à l'une ne verrait pas les
votes émis sur l'autre, et rien ne le signalerait.

**Ne pas ajouter `rewrite-target` à l'Ingress.** Cette annotation, copiée
depuis une autre application, réécrirait `/api/auth/me` en `/` et casserait
toute l'API en silence.

**Ne pas réactiver les snippets nginx.** Ils sont désactivés pour de bonnes
raisons. Les en-têtes de sécurité se posent dans le `nginx.conf` du conteneur
web.

**Ne pas modifier une migration Flyway déjà appliquée.** Toute évolution du
schéma passe par un nouveau fichier `V<n>__*.sql`.
