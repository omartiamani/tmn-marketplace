---
name: capture
description: Note au backlog, sans interrompre le travail en cours, l'idée, la fonctionnalité ou le bug dont il vient d'être question — titre, type et parent déduits de la conversation, sans aucune question —, puis vérifie le ticket créé. À invoquer sur la commande /workflow:capture, ou quand l'utilisateur demande de noter quelque chose au backlog pour plus tard.
---

# capture

Note une idée au backlog avant qu'elle se perde, sans détourner le travail en cours. La spécification viendra plus tard, avec `workflow:specify` puis `workflow:to-tickets`.

**La capture est rapide et muette.** Elle tombe au milieu d'autre chose : ni question, ni validation, ni proposition. Tu décides seul de tout ce qui manque, tu crées, tu vérifies, tu rends compte en une ligne, puis tu reprends là où tu en étais.

## 1. Se situer

Prends dans `WORKFLOW.md` l'outil, les types, le statut initial, le dépôt de destination de chaque type, les champs obligatoires et la langue ; dans la section « Workflow tooling » du `CLAUDE.md`, les identifiants et les commandes de création. **Sans `WORKFLOW.md`, ne crée rien** — dis-le, propose `workflow:setup`, et reprends le travail en cours.

## 2. Déduire

**Ce qu'il faut capturer se déduit de la conversation** : l'idée, le défaut ou le besoin dont il vient d'être question. Un texte passé avec la commande sert d'indication, pas de titre. Plusieurs éléments à noter donnent plusieurs tickets.

- **Titre** — court, dans le vocabulaire du glossaire et dans la langue déclarée dans `WORKFLOW.md`.
- **Type** — un défaut constaté est un bug ; le reste prend le type des besoins à spécifier, selon la hiérarchie de `WORKFLOW.md`.
- **Parent** — celui qui s'impose, comme le ticket de la fonctionnalité où le bug se produit. Au moindre doute, aucun : le rattachement se fera à la spécification.
- **Description** — ce que la conversation a établi : ce qui a été constaté, où, et pourquoi c'est à faire. Rien de plus.
- **Dépôt** — celui que `WORKFLOW.md` désigne pour ce type.

Quand un point hésite, prends la lecture la plus probable et continue : le compte rendu la montre, l'utilisateur corrigera s'il le faut.

## 3. Écarter les doublons

Cherche dans les tickets ouverts le même sujet. Un doublon évident ne se recrée pas : donne son lien à la place. Une simple ressemblance ne bloque rien : crée, et cite le ticket proche dans le compte rendu.

## 4. Créer et vérifier

Crée le ticket avec les commandes du `CLAUDE.md` : type, parent, champs obligatoires, ajout au board, statut initial — selon `WORKFLOW.md`.

**Puis vérifie, avant de créer le suivant.** Relis le ticket tel que l'outil le restitue : son type, son parent, son statut, et sa présence sur le board, lue depuis le board lui-même. Un écart arrête la capture : rends compte de ce qui est créé et de l'écart.

## 5. Rendre compte, puis reprendre

Une ligne par ticket : son identifiant et son lien, son titre, son type, son parent ou son absence. Puis reprends le travail en cours, sans transition.

## Règles

- **Le `WORKFLOW.md`, le `CLAUDE.md` et le `README.md` du projet font foi** sur tout le reste : ils l'emportent sur les comportements par défaut de ce skill, et une règle locale se suit sans la discuter. Mais quand la contradiction est **forte** — un principe du skill et une règle du projet qui ne peuvent pas tenir ensemble —, arrête-toi, expose les deux, et demande ce qu'il faut mettre à jour : la documentation du projet, ou le skill lui-même quand la règle a vocation à valoir partout.
- **Aucune question.** Tout ce qui manque se déduit ; le compte rendu dit ce qui a été déduit.
- **Rien d'inventé.** Le ticket ne porte que ce que la conversation a établi : ni critère, ni piste, ni règle.
- **Statut initial seulement.** Un ticket capturé ne passe jamais en prêt, même s'il paraît clair.
- **Relu, pas supposé.** Un ticket n'est créé qu'une fois relu dans l'outil.
