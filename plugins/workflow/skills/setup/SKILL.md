---
name: setup
description: Détecte le gestionnaire de projet et les conventions de versioning, puis écrit les règles du projet dans un `WORKFLOW.md` versionné à la racine du dépôt, importé par le `CLAUDE.md` qui porte en plus les détails d'outillage. À invoquer pour initialiser ou reconfigurer le workflow, quand `WORKFLOW.md` est absent, ou quand il ne correspond plus à la réalité des outils.
---

# setup

Découvre une fois pour toutes comment le projet est piloté, et grave le résultat dans le dépôt. Deux objectifs : plus aucune session ne doit redécouvrir les statuts, les types de work items ou les conventions de branche ; et la configuration doit être **versionnée et rejouable** — la même pour toute personne qui développe sur le projet, et reproductible d'un projet à l'autre.

## Emplacement

Deux fichiers à la racine du dépôt, commités comme le reste :

- **`WORKFLOW.md`** — les règles du projet, valables pour quiconque y développe, humain comme IA : le tracker et le cycle de vie des tickets, la langue, les conventions Git, l'emplacement de la documentation, les dépôts.
- **`CLAUDE.md`** — importe `WORKFLOW.md` par une ligne `@WORKFLOW.md`, et ajoute une section **« Workflow tooling »** réservée à l'outillage : accès à l'outil, identifiants, commandes validées, commandes inopérantes. Un humain passe par l'interface de l'outil ; ces détails ne servent qu'à Claude.

Claude Code charge le `CLAUDE.md` à chaque session, et avec lui ce qu'il importe : les autres skills du plugin trouvent la configuration déjà dans leur contexte.

Jamais dans le répertoire du plugin : les skills sont partagés entre projets, la configuration est propre à chacun. **Jamais hors d'un dépôt** non plus : un fichier posé dans un dossier parent qui regroupe plusieurs dépôts n'est pas versionné, et ne se rejoue pas.

### Projet multi-dépôts

Une seule configuration pour tous les dépôts. Elle vit dans le **dépôt de pilotage** — celui qui porte la documentation transverse. S'il n'est pas évident, demande lequel ; n'en crée aucun.

Claude Code ne charge que le `CLAUDE.md` du répertoire de travail et de ses parents. Ajoute donc au `CLAUDE.md` de **chaque autre dépôt** une ligne qui importe celui du dépôt de pilotage — `@../<dépôt-de-pilotage>/CLAUDE.md` —, sans quoi une session ouverte dans un dépôt de code ignorerait les règles. Cet import suppose que les dépôts sont clonés côte à côte : inscris-le dans `WORKFLOW.md`. À la première session, Claude Code peut demander d'autoriser cet import situé hors du dépôt : c'est attendu.

## Processus

### 1. Vérifier l'existant

Si `WORKFLOW.md` existe déjà : lis-le, avec la section « Workflow tooling » du `CLAUDE.md`, annonce ce qu'ils contiennent, et demande si l'utilisateur veut **compléter**, **re-sonder** (rafraîchir depuis l'outil) ou **abandonner**. Ne les écrase jamais sans accord.

Si tu trouves un **`.claude/workflow.md`** — l'emplacement des versions antérieures du plugin —, c'est une migration. Répartis son contenu entre `WORKFLOW.md` et la section « Workflow tooling », sans re-sonder ce qu'il établit déjà sauf demande, et écarte ce qui n'a pas sa place dans un fichier versionné (voir les règles). Une fois les nouveaux fichiers écrits, propose de supprimer l'ancien.

### 2. Repérer la documentation existante

Avant toute question, cherche ce que le projet documente déjà : `CLAUDE.md` (racine, sous-répertoires, et global de l'utilisateur), `AGENTS.md`, `README.md`, `CONTRIBUTING.md`, `docs/`. Beaucoup de règles de gestion de projet et de conventions Git y sont souvent déjà écrites.

**Ne duplique jamais ces informations.** Quand une règle est déjà documentée dans un fichier lu par tous — `README.md`, `CONTRIBUTING.md`, `docs/` —, `WORKFLOW.md` se contente de **pointer vers le fichier** — chemin et section — au lieu de recopier son contenu. La documentation existante reste la source de vérité ; une copie divergerait au premier changement.

**Exception : les règles de projet écrites dans un `CLAUDE.md` ou un `AGENTS.md`.** Seule l'IA les lit. Quand elles relèvent de `WORKFLOW.md` — conventions Git, langue, cycle de vie des tickets —, propose de les y **déplacer**, pour qu'elles s'appliquent à tous ; le `CLAUDE.md` n'en garde que ce qui concerne l'outillage.

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
- les **automatisations** qui changent un statut toutes seules — fermeture d'un ticket, merge d'une pull request
- le mécanisme de **lien parent/enfant** (Parent link, sub-issue, epic link, champ personnalisé)
- les **champs obligatoires** à la création
- les labels / tags disponibles s'ils servent au tri
- les **identifiants** dont les commandes auront besoin — projet, champ de statut, options

Si une commande échoue (non authentifié, extension absente, droits insuffisants), dis-le explicitement, indique la commande à lancer pour corriger, et poursuis en interview sur cette partie plutôt que d'inventer.

`PROBES.md` n'est qu'un point de départ. Consigne dans la section « Workflow tooling » du `CLAUDE.md` toute commande de ce fichier qui s'est révélée inopérante (avec l'erreur et la variante retenue), ainsi que toute commande ou appel API absent de la liste mais nécessaire au projet.

### 5. Compléter par interview

Ce qui n'est pas sondable, demande-le. Une question à la fois, groupée par thème :

- **Transitions** : quel statut à la création d'un ticket, au démarrage d'une tâche, quand le code est prêt, à la fin ? Que signifie chaque statut — quand un ticket y entre-t-il ? Qui fait la transition finale — toi ou l'utilisateur ?
- **Langue** : dans quelle langue sont écrits les artefacts du dépôt — specs, tickets, commits, documentation ? Cherche d'abord la règle dans le `CLAUDE.md` ou le `README` avant de demander ; beaucoup de projets l'ont déjà tranchée.
- **Dépôt de pilotage** — uniquement sur un projet multi-dépôts : lequel porte la configuration et la documentation transverse ?
- **Dépôt de destination** — uniquement si le tracker rattache les tickets à un dépôt, comme GitHub, **et** que le projet en compte plusieurs : quel type de ticket est créé dans quel dépôt ? Sur un tracker indépendant des dépôts ou sur un mono-repo, n'en parle pas.
- **Documentation** : où vivent les specs, le `CONTEXT.md`, les ADR ?
- **Git** : modèle de branches, format des branches, convention de commit, stratégie merge/rebase, branche d'intégration.

Ne propose jamais une valeur comme acquise. Si tu as une hypothèse (issue du `CLAUDE.md` du projet, par exemple), présente-la comme une hypothèse à confirmer.

### 6. Restituer avant d'écrire

Présente une synthèse compacte de ce qui va être écrit : le contenu de `WORKFLOW.md`, celui de la section « Workflow tooling » et, sur un projet multi-dépôts, les imports ajoutés dans chaque dépôt. L'utilisateur valide ou corrige. **Puis seulement** écris, en suivant [WORKFLOW-TEMPLATE.md](./WORKFLOW-TEMPLATE.md) et [CLAUDE-TEMPLATE.md](./CLAUDE-TEMPLATE.md).

Un `CLAUDE.md` existant ne se réécrit pas : ajoute l'import en tête et la section « Workflow tooling » à la fin, et ne touche au reste que pour les déplacements validés à l'étape 2.

### 7. Confirmer

Liste les fichiers écrits ou modifiés, dépôt par dépôt, et rappelle qu'ils sont éditables à la main — les skills du plugin `workflow` les reliront tels quels. **Propose le commit sans le faire** : la configuration n'est partagée qu'une fois versionnée, mais c'est à l'utilisateur d'en décider.

## Divergences entre le workflow documenté et la réalité des outils

Cette règle vaut pendant l'init **et à tout moment ensuite** : dès qu'un écart est constaté entre ce que décrivent `WORKFLOW.md`, le `CLAUDE.md` ou la documentation du projet et ce que renvoie réellement l'outil, signale-le immédiatement au lieu de t'adapter en silence.

Exemples d'écart : un statut documenté qui n'existe plus, un type de work item renommé, un area path ou un projet déplacé, un champ devenu obligatoire, une convention de branche que le dépôt ne respecte plus.

Procédure :

1. **Annonce l'écart** en montrant les deux versions : ce qui est documenté (avec le fichier et la section) et ce qui est constaté (avec la commande et sa sortie).
2. **Propose une mise à jour précise** — le fichier à modifier, la ligne actuelle, la ligne proposée. Si l'écart concerne une doc référencée (`README.md`, `CONTRIBUTING.md`…), la mise à jour porte sur ce fichier-là, pas sur une copie dans `WORKFLOW.md`.
3. **Attends la validation de l'utilisateur.** Il peut trancher dans l'autre sens : c'est l'outil qui est mal configuré, et la documentation qui fait foi.
4. **N'applique la modification qu'après accord.** Sans réponse, poursuis la tâche en cours en utilisant la valeur constatée et rappelle que l'écart reste non tranché.

Ne corrige jamais une documentation de ta propre initiative, et ne modifie jamais la configuration de l'outil pour la faire coller à la documentation.

## Règles

- **Le `WORKFLOW.md`, le `CLAUDE.md` et le `README.md` du projet font foi** sur tout le reste : ils l'emportent sur les comportements par défaut de ce skill, et une règle locale se suit sans la discuter. Mais quand la contradiction est **forte** — un principe du skill et une règle du projet qui ne peuvent pas tenir ensemble —, arrête-toi, expose les deux, et demande ce qu'il faut mettre à jour : la documentation du projet, ou le skill lui-même quand la règle a vocation à valoir partout.
- **Rien d'inventé.** Un champ dont la valeur n'a été ni sondée ni confirmée reste marqué `À DÉTERMINER` dans le fichier plutôt que rempli au jugé.
- **Orthographe exacte.** Les noms de statuts, types et champs sont recopiés tels que l'outil les renvoie, casse comprise. Une transition échoue sur une majuscule.
- **Lecture seule.** L'init ne crée, ne modifie et ne ferme aucun work item.
- **Zéro duplication.** Toute règle déjà écrite dans un `README.md`, un `CONTRIBUTING.md` ou une doc du projet est référencée par son chemin, pas recopiée. Celles d'un `CLAUDE.md` ou d'un `AGENTS.md` se déplacent dans `WORKFLOW.md`, après accord.
- **Versionné et rejouable.** Rien de ce qui décrit le projet ne s'écrit hors d'un dépôt. Aucune donnée propre à un poste dans les fichiers : ni chemin absolu, ni compte personnel, ni état local (stash, branche en cours).
- **Seulement l'établi.** Les fichiers décrivent ce qui est établi. Un point encore à trancher se signale dans la conversation ou devient un ticket — jamais une liste de points ouverts dans un fichier versionné.
- **Écarts signalés, jamais absorbés.** Une divergence entre doc et outil se signale et se fait trancher par l'utilisateur.
- **Concision.** Le `CLAUDE.md` et ce qu'il importe sont chargés à chaque session : va à l'essentiel, pas de prose explicative.
