# Commandes de sondage (lecture seule)

Ce fichier est un **point de départ**, pas une référence exhaustive ni garantie : les CLI et les API évoluent, et chaque organisation expose des champs et des endpoints qui lui sont propres.

Règle : **n'inscris dans `.claude/workflow.md` qu'une commande que tu as réellement exécutée avec succès.** Si une commande échoue ou n'existe pas dans la version installée, cherche l'équivalent, puis à défaut bascule en interview sur ce point.

Deux cas à consigner systématiquement dans la section « Commandes de référence » de `workflow.md`, pour qu'aucune session ultérieure ne refasse la découverte :

- **une commande d'ici qui ne fonctionne pas** — note-la comme inopérante, avec l'erreur obtenue et la variante qui a marché à sa place ;
- **une commande absente d'ici mais nécessaire** — note-la telle que tu l'as validée (requête WIQL, endpoint REST, appel MCP, champ personnalisé…).

Ne modifie pas ce fichier pour y consigner ces découvertes : elles sont propres au projet et vont dans `workflow.md`.

## Azure DevOps Boards

Prérequis : `az` + extension `azure-devops`, authentifié (`az login`, `az devops login`).

```bash
az devops configure --list                       # org/projet par défaut
az devops project list -o table
az boards area project list --project <PROJ> -o table
az boards iteration project list --project <PROJ> -o table
az boards work-item relation list-type -o table  # types de liens (Parent/Child…)
# Types de work items du process
az devops invoke --area wit --resource workitemtypes \
  --route-parameters project=<PROJ> --api-version 7.1 -o json
# Statuts d'un type donné
az devops invoke --area wit --resource states \
  --route-parameters project=<PROJ> type=<TYPE> --api-version 7.1 -o json
# Repli : lire un work item réel et observer ses champs/état
az boards work-item show --id <ID> -o json
```

## GitHub Issues / Projects

Prérequis : `gh` authentifié (`gh auth status`).

```bash
gh repo view <owner>/<repo> --json name,defaultBranchRef,hasIssuesEnabled
gh label list --repo <owner>/<repo>
gh project list --owner <owner>
gh project field-list <number> --owner <owner>   # champ Status et ses options
gh issue list --repo <owner>/<repo> --limit 5 --json number,title,labels,state
# Sous-issues (relation parent/enfant native)
gh api repos/<owner>/<repo>/issues/<n>/sub_issues
```

Note : GitHub n'a que deux états natifs (`open`/`closed`). Le vrai cycle de vie vient du champ **Status** d'un Project v2 ou de labels — sonde `field-list` et note les options exactes.

## Jira

Pas de CLI officielle installée. Utilise dans l'ordre : un serveur MCP Jira connecté, sinon l'API REST avec les identifiants fournis par l'utilisateur (ne demande jamais un token en clair dans la conversation — demande une variable d'environnement déjà présente).

```bash
: "${JIRA_URL:?}" "${JIRA_USER:?}" "${JIRA_TOKEN:?}"
curl -su "$JIRA_USER:$JIRA_TOKEN" "$JIRA_URL/rest/api/3/project/search"
curl -su "$JIRA_USER:$JIRA_TOKEN" "$JIRA_URL/rest/api/3/issuetype"
curl -su "$JIRA_USER:$JIRA_TOKEN" "$JIRA_URL/rest/api/3/status"
curl -su "$JIRA_USER:$JIRA_TOKEN" "$JIRA_URL/rest/api/3/issue/<KEY>/transitions"
```

## Fichiers locaux

Rien à sonder. Établis la convention avec l'utilisateur et inscris-la :

- un fichier par ticket sous `.claude/tickets/<ID>-<slug>.md`
- identifiant, type, statut, parent en frontmatter YAML
- statuts par défaut : `todo`, `in-progress`, `review`, `done`
- lien parent/enfant : champ `parent:` référençant l'identifiant du parent
