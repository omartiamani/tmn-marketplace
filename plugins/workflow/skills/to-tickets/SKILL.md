---
name: to-tickets
description: Découpe un besoin ou une spec en work items (Epics, Features, User Stories, Tasks, Bugs), les propose par lots pour validation, puis les crée dans le gestionnaire de projet configuré en rattachant chaque enfant à son parent. À invoquer quand l'utilisateur demande de découper, planifier, créer des tickets ou alimenter le backlog.
---

# to-tickets

Transforme une spec ou une discussion en work items. **Rien n'est écrit sur l'outil avant validation** : tu proposes, l'utilisateur valide, tu publies.

Un ticket est lu des semaines plus tard, par quelqu'un — ou une session — qui n'a pas assisté à la discussion. Il doit donc être **auto-contenu** : tout ce qu'il faut pour comprendre et implémenter y figure, sans avoir à ouvrir la spec. C'est un instantané de ce qui était valable au moment de sa création, et c'est précisément ce qui fait sa valeur quand la spec, elle, aura bougé.

## 1. Se situer

Lis `.claude/workflow.md` : outil, hiérarchie des types, statuts, mécanisme de lien parent/enfant, champs obligatoires, commandes de référence. **Sans lui, ne crée rien** — propose `workflow:setup`. Créer des work items avec une nomenclature devinée produit un backlog qu'il faudra reprendre à la main.

Rassemble la matière : la spec du sujet, la discussion en cours, le glossaire, et le code pour ce qui existe déjà.

**Puis lève les zones d'ombre, avant de rédiger quoi que ce soit.** Liste ce qui n'est pas tranché — règle métier absente, cas limite non traité, choix technique structurant — et pose ces points à l'utilisateur, un par un. Si le sujet est trop large pour quelques questions, propose `workflow:specify`. Un ticket rédigé par-dessus une zone d'ombre la fige : elle ressortira à l'implémentation, quand elle coûtera plus cher.

Si `workflow.md` déclare un **dépôt de destination par type de ticket** — cas d'un tracker qui rattache les tickets à un dépôt, comme GitHub, sur un projet multi-repo — c'est lui qui décide, jamais le répertoire courant. En l'absence de cette règle, la question ne se pose pas : le tracker est indépendant des dépôts, ou il n'y en a qu'un.

## 2. Chercher l'existant

Avant de découper, cherche les work items déjà ouverts sur le sujet. Rattache-toi à un parent existant plutôt que d'en créer un nouveau, et **signale tout doublon ou contradiction** au lieu de créer par-dessus. Un backlog vivant se dégrade vite quand deux tickets décrivent le même travail.

## 3. Découper en tranches verticales

Chaque User Story traverse **toutes les couches** — schéma, API, interface, tests — et livre un comportement démontrable de bout en bout. Une US n'est pas « faire l'API des baux » suivie de « faire l'écran des baux » : séparées, aucune des deux ne prouve quoi que ce soit.

Une bonne tranche est **vérifiable seule**, et tient dans une seule session de travail. Si elle n'y tient pas, elle est trop grosse.

Deux exceptions à la verticalité :

- **Le prérequis technique** qui ne livre rien d'observable mais conditionne la suite — une migration, un socle. Il devient une US à part, placée en tête, et déclarée bloquante pour celles qui en dépendent.
- **Le refactor large** dont le rayon d'impact traverse tout le code — un renommage, un changement de type partagé. Il ne rentre dans aucune tranche verticale. Séquence-le : d'abord ajouter la nouvelle forme à côté de l'ancienne, puis migrer les appelants par lots, enfin supprimer l'ancienne — chaque étape étant sa propre tâche, bloquée par la précédente.

Déclare les **dépendances bloquantes** : pour chaque item, ce qui doit être terminé avant qu'il puisse commencer. Une tâche sans bloqueur est démarrable tout de suite.

## 4. Rédiger

**Rédige dans la langue déclarée dans `.claude/workflow.md`**, quelle que soit la langue de la conversation.

**Titre** : verbe à l'infinitif, court, dans le vocabulaire du glossaire — « Filtrer les baux par statut ». Il doit se lire dans une colonne de board.

**Description** :

- **Contexte** — le pourquoi, l'état actuel de ce qui est touché, et les règles métier et cas limites qui s'appliquent à ce ticket précis. Reprends-les depuis la spec : le ticket doit se suffire à lui-même.
- **Objectif** — ce que le ticket rend possible.
- **Critères d'acceptance** — ce qui doit être vrai à la fin, formulé de façon vérifiable. Un critère qu'on ne peut pas tester n'est pas un critère.
- **Pistes techniques** — modules concernés, approche envisagée, points d'attention repérés pendant la discussion. Ce qui a été discuté uniquement.
- **Dépendances** — les items bloquants.

Ne reprends de la spec que ce qui concerne **ce ticket** : auto-contenu ne veut pas dire recopier la spec entière. Et n'invente aucun critère d'acceptance qui n'ait été discuté — si un critère te paraît manquer, dis-le dans le lot proposé, pas dans le ticket.

**Un ticket consigne des décisions prises, jamais un arbitrage ouvert.** Si un choix se présente pendant la rédaction, pose-le et attends la réponse ; n'écris ensuite que la décision retenue et son motif. Écrire « deux options, à trancher dans le ticket » reporte la charge sur le prochain lecteur au lieu de la lever. Et un choix qui n'engage rien ne se consigne pas du tout : consigner une décision non structurante encombre le ticket sans rien protéger.

Le ticket est daté et figé. Si la spec évolue ensuite, il ne suit pas automatiquement : l'écart se constate et se traite au moment de l'implémentation.

## 5. Proposer par lots

Un niveau à la fois, du haut vers le bas : les Epics et Features d'abord, puis les User Stories du périmètre validé, puis les tâches. Chaque niveau est figé avant de détailler le suivant.

**Un ticket seul est un lot de un** : il se propose et se valide comme les autres. Le fait qu'il n'y en ait qu'un ne dispense de rien.

Pour chaque lot, présente une liste numérotée avec le titre, le parent, les bloqueurs et ce que l'item livre. Demande explicitement : la granularité est-elle bonne, les dépendances sont-elles justes, faut-il fusionner ou scinder ? Itère jusqu'à validation.

## 6. Publier

Uniquement après validation, et dans l'ordre de la hiérarchie : les parents d'abord, pour que les enfants puissent référencer des identifiants réels.

Pour chaque item : créer, **rattacher au parent**, renseigner les champs obligatoires, appliquer le statut initial et les dépendances bloquantes — le tout selon `workflow.md`.

**Si une création échoue, arrête-toi immédiatement.** Rends compte : ce qui a été créé avec les identifiants réels, ce qui reste à créer, et l'erreur exacte. Ne poursuis pas le lot — un parent manquant produit des enfants orphelins. Ne supprime rien pour « repartir propre ».

Termine en restituant l'arborescence créée avec les identifiants réels.

## Règles

- **Le `CLAUDE.md` et le `README.md` du projet font foi** sur tout le reste : ils l'emportent sur les comportements par défaut de ce skill, et une règle locale se suit sans la discuter. Mais quand la contradiction est **forte** — un principe du skill et une règle du projet qui ne peuvent pas tenir ensemble —, arrête-toi, expose les deux, et demande ce qu'il faut mettre à jour : la documentation du projet, ou le skill lui-même quand la règle a vocation à valoir partout.
- **Rien d'écrit sans validation.** Les lots se valident avant publication, sans exception.
- **Aucun ticket sans parent**, sauf au sommet de la hiérarchie. Le rattachement fait partie de la création, pas d'une passe ultérieure.
- **Le ticket est auto-contenu.** Il porte le contexte, les règles et les critères qui le concernent, et reste implémentable sans ouvrir la spec — c'est un instantané, pas un renvoi.
- **N'invente ni règle ni critère.** Ce qui n'a pas été discuté se signale dans le lot, jamais dans le ticket.
