# Gabarit des ajouts au `CLAUDE.md`

Le `CLAUDE.md` du dépôt reçoit deux ajouts, et le reste ne change pas :

1. **en tête**, l'import des règles du projet : `@WORKFLOW.md` ;
2. **à la fin**, la section « Workflow tooling » ci-dessous.

S'il n'existe pas, crée-le avec ces deux seuls éléments.

Mêmes règles que pour `WORKFLOW.md` : langue des artefacts du projet, valeurs non confirmées marquées `À DÉTERMINER`, aucune donnée propre à un poste — ni chemin absolu, ni compte personnel.

Si une section est sans objet — un outil sans identifiant, aucune commande inopérante —, supprime-la.

---

````markdown
@WORKFLOW.md

<contenu existant du CLAUDE.md, inchangé>

## Workflow tooling

Outillage du workflow décrit dans `WORKFLOW.md`, à l'usage de Claude.

### Accès

- **Outil** : CLI `az boards` | CLI `gh` | MCP <nom du serveur> | répertoire `.claude/tickets/`
- **Authentification** : <mécanisme, et particularités d'environnement — variable à ré-exporter, fichier à sourcer>

### Identifiants

| Élément | Identifiant |
| ------- | ----------- |
| ...     | ...         |

### Règles propres à l'IA

- **Changements de statut** : automatiques | sur confirmation explicite de l'utilisateur

### Commandes de référence

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

### Commandes inopérantes

Variantes essayées qui ne fonctionnent pas ici — à ne pas retenter sauf en dernier recours.

| Commande | Erreur | Variante retenue |
| -------- | ------ | ---------------- |
| ...      | ...    | ...              |
````

---

## Autres dépôts d'un projet multi-dépôts

Leur `CLAUDE.md` reçoit une seule ligne, en tête, qui importe celui du dépôt de pilotage :

```markdown
@../<dépôt-de-pilotage>/CLAUDE.md
```

Pas de section « Workflow tooling » ni de `WORKFLOW.md` dans ces dépôts : l'import les apporte.
