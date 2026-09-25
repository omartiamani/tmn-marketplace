# Gabarit de `WORKFLOW.md`

Recopie cette structure. Supprime les sections sans objet. Toute valeur non confirmée reste `À DÉTERMINER`.

**Rédige le fichier dans la langue déclarée pour les artefacts du projet, titres compris** : les titres ci-dessous indiquent le contenu attendu, pas leur formulation.

Ce fichier est lu par des humains. Pas d'identifiant technique ni de commande : ils vont dans la section « Workflow tooling » du `CLAUDE.md` (voir [CLAUDE-TEMPLATE.md](./CLAUDE-TEMPLATE.md)). Pas de chemin absolu, pas de compte personnel, pas de liste de points ouverts.

Si une section est déjà documentée dans un fichier lu par tous (`README.md`, `CONTRIBUTING.md`, `docs/`), remplace son contenu par un simple renvoi plutôt que par une copie :

```markdown
## Conventions Git

Voir `CONTRIBUTING.md` § « Branches ». Ne pas dupliquer ici.
```

---

````markdown
# Workflow

> Règles du projet, valables pour toute personne qui y développe.
> Générées par `workflow:setup`, éditables à la main.

## Gestionnaire de projet

- **Outil** : Azure DevOps Boards | GitHub Projects | Jira | Fichiers locaux
- **Organisation / Projet** : <valeurs exactes>
- **Board / Area path / Itération par défaut** : <valeurs exactes>
- **Accès** : <URL du board>

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

| Type       | Statuts disponibles (orthographe exacte) | À la création | Au démarrage | Code prêt | Terminé |
| ---------- | ---------------------------------------- | ------------- | ------------ | --------- | ------- |
| User Story | New, Active, Resolved, Closed            | New           | Active       | Resolved  | Closed  |
| Task       | ...                                      | ...           | ...          | ...       | ...     |

- **Sens des statuts** : <quand un ticket entre dans chacun — par exemple ce qui le rend « prêt »>
- **Automatisations de l'outil** : <ce qui change de statut tout seul — fermeture, merge…>
- **Qui ferme le parent** : jamais automatiquement | ...

## Liens parent / enfant

- **Mécanisme** : Parent link | sub-issue | epic link | champ `<nom>`

## Champs obligatoires à la création

| Type | Champs requis |
| ---- | ------------- |
| ...  | ...           |

## Labels / tags utilisés

- `<label>` — <à quoi il sert>

## Langue

- **Langue des artefacts écrits** (specs, glossaire, ADR, tickets, commits, branches, pull requests, documentation, commentaires de code) : <valeur>

La langue de la conversation n'a aucune incidence sur celle-ci.

## Documentation

- **Specs** : <chemin>
- **Glossaire (CONTEXT.md)** : <chemin>
- **ADR** : <chemin> — et le critère qui justifie un ADR, s'il a été fixé

## Dépôts

Section à supprimer sur un mono-repo.

| Dépôt | Rôle |
| ----- | ---- |
| ...   | ...  |

Clonez tous les dépôts côte à côte, dans un même dossier : le `CLAUDE.md` de chacun
importe celui de `<dépôt de pilotage>` par un chemin relatif.

## Conventions Git

- **Modèle de branches** : <GitHub Flow | Git Flow | trunk-based…>
- **Branche d'intégration** : <nom>
- **Nommage des branches** : <format>
- **Commits** : <convention>
- **Pull requests** : <format du titre, contenu du corps, mots-clés de fermeture>
- **Stratégie** : intégration = <merge | rebase | squash>, mise à jour = <...>
````
