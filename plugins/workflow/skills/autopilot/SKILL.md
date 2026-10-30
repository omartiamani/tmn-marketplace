---
name: autopilot
description: "Variante autonome de workflow:implement — implémente une tâche et toutes ses tâches enfants d'une traite, sans aucune question ni validation : chaque lot confié à l'agent implementer (plan, TDD, vérification dans l'application, commits), puis push, pull request mise à jour, contrôlée par workflow:check-pr et passée en revue. Ne jamais déclencher de soi-même : uniquement sur la commande /workflow:autopilot ou sur une demande explicite de travailler en autonomie."
disable-model-invocation: true
---

# autopilot

La variante autonome de `workflow:implement`. Elle va d'une traite du ticket à la pull request : l'utilisateur ne juge le travail qu'en relisant la pull request.

**Tu orchestres, les tâches s'implémentent ailleurs.** Chaque lot de tâches va à l'agent [`workflow:implementer`](../../agents/implementer.md), qui applique `workflow:implement` en autonomie jusqu'aux commits. Toi, tu tiens la pull request selon [workflow:to-pr](../to-pr/SKILL.md) et tu la contrôles avec [workflow:check-pr](../check-pr/SKILL.md), avec les seules différences décrites ici. Partout où l'un d'eux attend un accord ou pose une question, c'est la règle de ce skill qui s'applique, et tu continues. Ton contexte doit tenir toute une fonctionnalité : il ne garde que l'arborescence, les comptes rendus des lots et la pull request, jamais le code.

L'autonomie porte sur les validations, pas sur la rigueur : ce sont les allers-retours qui sautent.

## Le déroulé

1. **Le périmètre** : l'arborescence complète sous l'identifiant fourni, l'ordre de ses dépendances bloquantes, les dépôts concernés, la branche de travail — et son découpage en lots.
2. **Chaque lot, confié à l'agent `workflow:implementer`**, dans l'ordre des dépendances. À son retour : le jugement de son compte rendu, puis le push de la branche, la mise à jour de la pull request selon `workflow:to-pr` pour chaque tâche terminée, et leur statut suivant. Un lot est terminé et vérifié avant que le suivant commence.
3. **Une fois le périmètre terminé** : `workflow:check-pr` sur chaque pull request, les corrections qu'il appelle, puis le passage en revue de celles qui sont prêtes.
4. **Le compte rendu final.**

## Les lots

**Découpe d'abord le périmètre en lots.** Un lot regroupe les tâches qui se font mieux d'une traite qu'en se passant le relais : dépendantes les unes des autres, elles touchent le même code, et sont assez petites pour tenir ensemble dans un seul contexte. Séparées, la seconde devrait redécouvrir ce que la première vient d'écrire. Une tâche qui ne partage rien avec les autres forme un lot à elle seule, comme celle qui occuperait seule un contexte. Décide sur les tickets — dépendances, pistes techniques, modules nommés — sans lire le code toi-même, et montre le découpage avant de lancer le premier lot.

Les lots se succèdent, jamais en parallèle, même indépendants : ils partageraient la branche, l'arbre de travail, les serveurs et le simulateur de vérification.

Donne à l'agent ce que sa définition attend : les identifiants des tâches du lot dans l'ordre, les dépôts et la branche de travail, et des lots précédents seulement ce qui l'engage. Il te rend un compte rendu tâche par tâche : montre au fil de l'eau les plans et les verdicts qu'il rapporte.

**Juge chaque compte rendu avant de toucher à la pull request**, sans relire le code :

- chaque critère d'acceptance du ticket — relu dans le ticket, pas dans le compte rendu — y figure, avec ce qui le prouve ;
- les commits annoncés existent sur la branche ;
- une tâche dite terminée n'a ni test, lint ou build rouge, ni vérification sautée sans raison.

Un écart renvoie la tâche à l'agent, avec l'écart à combler. Elle n'entre dans la pull request qu'une fois cohérente ; si l'écart persiste, il va dans les notes au relecteur et la tâche reste hors de la pull request.

## Ce qui change

**Ce qui s'est décidé sans l'utilisateur se montre là où il relit.** Pour une décision que `workflow:to-pr` lui laisserait, retiens l'hypothèse la plus raisonnable. Les décisions, les écarts avec les tickets et les vérifications sautées — les tiens comme ceux que rapporte l'agent — vont à deux endroits : dans les notes au relecteur de la pull request, et dans le compte rendu final.

**Git.** Pousse la branche de travail au retour de chaque lot, sans demander. Un dépôt qui travaille directement sur sa branche principale reçoit ses commits sans push : signale-les.

**La pull request.** Ouvre-la ou mets-la à jour selon `workflow:to-pr` au retour de chaque lot. **Marque-la prête pour la revue sans demander** dès que `workflow:to-pr` le permet — tous les enfants de son parent y sont — et que `check-pr` ne laisse aucun problème non corrigé. Sinon, elle reste en brouillon, et le compte rendu dit ce qui manque.

**Le contrôle.** Une fois le périmètre terminé, lance `workflow:check-pr`, même si la pull request n'a pas encore tous les enfants de son parent : c'est le regard neuf qui passe avant celui de l'utilisateur. Applique ses corrections sans accord :

- le code, par l'agent `workflow:implementer`, les problèmes à corriger tenant lieu de tickets, puis push ;
- la description, en recomposant le corps selon `workflow:to-pr`.

Un ticket qui s'écarte du code ne se corrige pas : l'écart va dans les notes au relecteur. Après chaque correction, rejoue les contrôles touchés. Un problème qui survit à sa correction ne se reprend pas en boucle : il va dans les notes au relecteur. La complétude ne compte qu'au passage en revue : un enfant hors périmètre qui manque à la pull request n'est pas un problème à corriger.

**Statuts.** Passe chaque tâche terminée au statut suivant, comme `workflow:implement` — souvent par la seule référence que `workflow:to-pr` ajoute. **Ne pousse aucune transition finale** : la clôture appartient à la revue humaine.

## Quand s'arrêter quand même

L'autonomie ne va pas jusqu'à livrer du rouge. Arrête-toi et rends compte si :

- l'agent `workflow:implementer` ne peut pas se lancer — une session ouverte avant l'installation du plugin ne le voit pas ;
- un lot revient arrêté ;
- un contrôle préalable de `workflow:to-pr` échoue et ne se règle pas dans les limites ci-dessous — une branche déjà poussée qu'il faudrait rebaser, par exemple ;
- un principe du workflow et une règle du projet ne peuvent pas tenir ensemble ;
- une limite absolue est atteinte.

Ce qui est déjà terminé et vert reste commité, poussé et dans la pull request ; rien de rouge ne se pousse. Un arrêt honnête à mi-parcours vaut mieux qu'un compte rendu qui déclare terminé ce qui ne l'est pas.

## Limites absolues

Les [limites absolues de l'agent](../../agents/implementer.md#limites-absolues) valent pour toi aussi, et aucune autonomie ne les lève. Pour toi, celle sur les work items laisse aussi passer le statut suivant, jamais la transition finale. S'y ajoute : **ni fusion, ni push sur la branche d'intégration.**

## Compte rendu final

En une seule fois, à la fin : le lien de chaque pull request, prête pour la revue ou en brouillon et pourquoi, les tâches traitées et leur état, ce que `check-pr` a remonté et ce qui en a été corrigé, les décisions prises en autonomie, les fichiers de documentation modifiés, les vérifications sautées et pourquoi, les données laissées en place, le débordement rencontré, et les commits non poussés.
