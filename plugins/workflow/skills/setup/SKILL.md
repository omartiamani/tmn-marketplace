---
name: setup
description: Détecte le gestionnaire de projet et les conventions de versioning du dépôt, et écrit leurs règles dans `.claude/workflow.md`, lu par les skills du plugin `workflow`. À invoquer pour initialiser ou reconfigurer le workflow, quand `workflow.md` est absent, ou quand il ne correspond plus à la réalité des outils.
---

# setup

Découvre une fois pour toutes comment le projet est piloté, et grave le résultat dans `.claude/workflow.md`. Objectif : plus aucune session ne doit redécouvrir les statuts, les types de work items ou les conventions de branche.

## Emplacement

La configuration vit à la **racine du projet en cours** — le répertoire de travail courant — dans `.claude/workflow.md`. Ce n'est jamais le répertoire du plugin : les skills sont partagés entre projets, la configuration est propre à chacun.

Quand la racine regroupe plusieurs repositories, une seule configuration les couvre tous. Ne crée pas de configuration par repository.

## Processus

### 1. Vérifier l'existant

Si `.claude/workflow.md` existe déjà : lis-le, annonce ce qu'il contient, et demande si l'utilisateur veut le **compléter**, le **re-sonder** (rafraîchir depuis l'outil) ou **abandonner**. Ne l'écrase jamais sans accord.

### 2. Repérer la documentation existante

Avant toute question, cherche ce que le projet documente déjà : `CLAUDE.md` (racine, sous-répertoires, et global de l'utilisateur), `AGENTS.md`, `README.md`, `CONTRIBUTING.md`, `docs/`. Beaucoup de règles de gestion de projet et de conventions Git y sont souvent déjà écrites.

**Ne duplique jamais ces informations.** Quand une règle est déjà documentée ailleurs, `workflow.md` se contente de **pointer vers le fichier** — chemin et section — au lieu de recopier son contenu. La documentation existante reste la source de vérité ; une copie divergerait au premier changement.

Ne recopie une information que si elle n'existe nulle part, ou si elle est contredite par ce que tu as sondé — dans ce cas signale la contradiction à l'utilisateur et demande quelle version fait foi.

### 3. Détecter le gestionnaire de projet

Cherche des indices avant de demander :

- remote git (`git -C <repo> remote -v`) → `dev.azure.com`/`visualstudio.com` = Azure DevOps, `github.com` = GitHub
- CLI disponibles : `az` + extension `azure-devops`, `gh`
- serveurs MCP connectés exposant des outils Jira/Azure/GitHub
- répertoire `.claude/tickets/` existant = mode fichiers locaux

Annonce l'outil détecté et fais-le **confirmer**. Si rien n'est détecté ou si plusieurs candidats coexistent, demande — ne devine pas.

### 4. Sonder l'outil

Exécute les commandes de découverte de [PROBES.md](./PROBES.md) pour l'outil retenu. Le sondage est en **lecture seule** : aucune commande de création ou de modification pendant l'init.

Ce qu'il faut ramener :

- l'identité du projet (organisation, projet, repo, board, area path, itération courante)
- la **hiérarchie réelle** des types (ex. Epic → Feature → User Story → Task/Bug) telle que l'outil la nomme
- les **statuts exacts** de chaque type, avec leur orthographe exacte (`New`, `Active`, `Resolved`, `Closed`…)
- le mécanisme de **lien parent/enfant** (Parent link, sub-issue, epic link, champ personnalisé)
- les **champs obligatoires** à la création
- les labels / tags disponibles s'ils servent au tri

Si une commande échoue (non authentifié, extension absente, droits insuffisants), dis-le explicitement, indique la commande à lancer pour corriger, et poursuis en interview sur cette partie plutôt que d'inventer.

`PROBES.md` n'est qu'un point de départ. Consigne dans `workflow.md` toute commande de ce fichier qui s'est révélée inopérante (avec l'erreur et la variante retenue), ainsi que toute commande ou appel API absent de la liste mais nécessaire au projet.

### 5. Compléter par interview

Ce qui n'est pas sondable, demande-le. Une question à la fois, groupée par thème :

- **Transitions** : quel statut au démarrage d'une tâche, lequel quand le code est prêt, lequel à la fin ? Qui fait la transition finale — toi ou l'utilisateur ?
- **Documentation** : où vivent les specs, le `CONTEXT.md`, les ADR ?
- **Git** : format des branches, convention de commit, stratégie merge/rebase, branche d'intégration.

Ne propose jamais une valeur comme acquise. Si tu as une hypothèse (issue du `CLAUDE.md` du projet, par exemple), présente-la comme une hypothèse à confirmer.

### 6. Restituer avant d'écrire

Présente une synthèse compacte de tout ce qui va être écrit. L'utilisateur valide ou corrige. **Puis seulement** écris `.claude/workflow.md` en suivant [WORKFLOW-TEMPLATE.md](./WORKFLOW-TEMPLATE.md).

### 7. Confirmer

Indique le chemin du fichier écrit, et rappelle qu'il est éditable à la main — les skills du plugin `workflow` le reliront tel quel.

## Divergences entre le workflow documenté et la réalité des outils

Cette règle vaut pendant l'init **et à tout moment ensuite** : dès qu'un écart est constaté entre ce que décrivent `workflow.md` ou la documentation du projet et ce que renvoie réellement l'outil, signale-le immédiatement au lieu de t'adapter en silence.

Exemples d'écart : un statut documenté qui n'existe plus, un type de work item renommé, un area path ou un projet déplacé, un champ devenu obligatoire, une convention de branche que le dépôt ne respecte plus.

Procédure :

1. **Annonce l'écart** en montrant les deux versions : ce qui est documenté (avec le fichier et la section) et ce qui est constaté (avec la commande et sa sortie).
2. **Propose une mise à jour précise** — le fichier à modifier, la ligne actuelle, la ligne proposée. Si l'écart concerne une doc référencée (`CLAUDE.md`, `README.md`…), la mise à jour porte sur ce fichier-là, pas sur une copie dans `workflow.md`.
3. **Attends la validation de l'utilisateur.** Il peut trancher dans l'autre sens : c'est l'outil qui est mal configuré, et la documentation qui fait foi.
4. **N'applique la modification qu'après accord.** Sans réponse, poursuis la tâche en cours en utilisant la valeur constatée et rappelle que l'écart reste non tranché.

Ne corrige jamais une documentation de ta propre initiative, et ne modifie jamais la configuration de l'outil pour la faire coller à la documentation.

## Règles

- **Rien d'inventé.** Un champ dont la valeur n'a été ni sondée ni confirmée reste marqué `À DÉTERMINER` dans le fichier plutôt que rempli au jugé.
- **Orthographe exacte.** Les noms de statuts, types et champs sont recopiés tels que l'outil les renvoie, casse comprise. Une transition échoue sur une majuscule.
- **Lecture seule.** L'init ne crée, ne modifie et ne ferme aucun work item.
- **Zéro duplication.** Toute règle déjà écrite dans un `CLAUDE.md`, un `AGENTS.md`, un `README.md` ou une doc du projet est référencée par son chemin, pas recopiée.
- **Écarts signalés, jamais absorbés.** Une divergence entre doc et outil se signale et se fait trancher par l'utilisateur.
- **Concision.** Le fichier est relu à chaque session par les autres skills : va à l'essentiel, pas de prose explicative.
