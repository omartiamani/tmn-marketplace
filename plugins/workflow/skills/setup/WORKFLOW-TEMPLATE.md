# Gabarit de `.claude/workflow.md`

Recopie cette structure. Supprime les sections sans objet. Toute valeur non confirmée reste `À DÉTERMINER`.

Si une section est déjà documentée ailleurs (`CLAUDE.md`, `AGENTS.md`, `README.md`, `docs/`), remplace son contenu par un simple renvoi plutôt que par une copie :

```markdown
## Conventions Git

Voir `CLAUDE.md` § « Workflow Git ». Ne pas dupliquer ici.
```

---

````markdown
# Configuration du workflow

> Généré par le skill setup le <AAAA-MM-JJ>. Éditable à la main.

## Gestionnaire de projet

- **Outil** : Azure DevOps Boards | GitHub Issues/Projects | Jira | Fichiers locaux
- **Accès** : CLI `az boards` | CLI `gh` | MCP <nom du serveur> | répertoire `.claude/tickets/`
- **Organisation / Projet** : <valeurs exactes>
- **Board / Area path / Itération par défaut** : <valeurs exactes>

## Hiérarchie des work items

| Niveau | Type (nom exact dans l'outil) | Contient   |
| ------ | ----------------------------- | ---------- |
| 1      | Epic                          | Feature    |
| 2      | Feature                       | User Story |
| 3      | User Story                    | Task, Bug  |
| 4      | Task, Bug                     | —          |

### Dépôt de destination

Section à supprimer si le tracker est indépendant des dépôts (Azure DevOps,
Jira) ou si le projet est mono-repo. Elle ne se renseigne que sur un tracker qui
rattache chaque ticket à un dépôt, comme GitHub, et sur un projet multi-repo.

| Type | Dépôt de destination |
| ---- | -------------------- |
| ...  | ...                  |

## Statuts et transitions

| Type       | Statuts disponibles (orthographe exacte) | Au démarrage | Code prêt | Terminé |
| ---------- | ---------------------------------------- | ------------ | --------- | ------- |
| User Story | New, Active, Resolved, Closed            | Active       | Resolved  | Closed  |
| Task       | ...                                      | ...          | ...       | ...     |

- **Transition finale** : automatique | sur confirmation de l'utilisateur
- **Qui ferme le parent** : jamais automatiquement | ...

## Liens parent / enfant

- **Mécanisme** : Parent link | sub-issue | epic link | champ `<nom>`
- **Commande / procédure** : <commande exacte de rattachement>

## Champs obligatoires à la création

| Type | Champs requis |
| ---- | ------------- |
| ...  | ...           |

## Labels / tags utilisés

- `<label>` — <à quoi il sert>

## Langue

- **Langue des artefacts écrits** (specs, glossaire, ADR, tickets, commits, documentation) : <valeur>
- **Source de la règle** : <fichier et section, ou « demandé à l'utilisateur »>

La langue de la conversation n'a aucune incidence sur celle-ci.

## Documentation

- **Specs** : <chemin>
- **Glossaire (CONTEXT.md)** : <chemin>
- **ADR** : <chemin>

## Repositories

| Repo | Chemin | Rôle |
| ---- | ------ | ---- |
| ...  | ...    | ...  |

## Conventions Git

- **Branche d'intégration** : <nom>
- **Nommage des branches** : <format>
- **Commits** : <convention>
- **Stratégie** : feature→intégration = <merge|rebase|squash>, mise à jour = <...>

## Commandes de référence

Commandes réellement exécutées avec succès, à réutiliser telles quelles. Complète cette section à chaque fois qu'une nouvelle commande ou un nouvel appel API est validé en cours de projet.

```bash
# Lire un work item
<commande>
# Créer un work item
<commande>
# Changer le statut
<commande>
# Lier un enfant à son parent
<commande>
```
````

### Commandes inopérantes

Variantes essayées qui ne fonctionnent pas ici — à ne pas retenter sauf en dernier recours.

| Commande | Erreur | Variante retenue |
| -------- | ------ | ---------------- |
| ...      | ...    | ...              |

```

```
