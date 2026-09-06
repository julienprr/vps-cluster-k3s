# Les secrets de cette application

Il n'y a **pas** de `secrets.yaml` en clair dans ce dossier, et il ne doit
jamais y en avoir. Le fichier scellé se génère avec `kubeseal`, à partir de
valeurs que tu ne commites pas.

Voir `scripts/deploy/seal-restaurateurs-secrets.sh`.

Le secret s'appelle `restaurateurs-secrets` et contient cinq clés, dont les
noms correspondent exactement aux variables d'environnement lues par l'API :

| Clé | Rôle |
|---|---|
| `DB_USER` | utilisateur Postgres, lu aussi par le StatefulSet |
| `DB_PASSWORD` | mot de passe Postgres, idem |
| `SMTP_USER` | identifiant de la clé SMTP Brevo |
| `SMTP_PASSWORD` | valeur de la clé SMTP Brevo |
| `MAIL_FROM` | adresse d'expédition, son domaine doit être validé chez Brevo |

Le StatefulSet Postgres lit `DB_USER` et `DB_PASSWORD` pour créer son compte :
une seule source de vérité, pas de valeur à tenir synchronisée à deux endroits.
