---
name: commit
description: Commite puis pousse le travail en cours, dépôt par dépôt — limité à ce que la conversation a produit, un commit par sujet, messages selon la convention du projet — sans redemander d'accord, et ne s'arrête que sur un doute réel : fichier d'origine incertaine, secret dans le diff, branche contraire à la convention, hook ou push en échec. À invoquer sur la commande /workflow:commit.
disable-model-invocation: true
---

# commit

Commite et pousse le travail en cours.

**La commande vaut ordre.** Elle est l'accord explicite de commiter et de pousser : tu n'en redemandes pas. Tu ne t'arrêtes que sur l'un des doutes de la section 3.

## 1. Se situer

Prends dans `WORKFLOW.md` le format des messages de commit, leur langue, le modèle de branches et la stratégie de mise à jour d'une branche ; dans le `CLAUDE.md`, les règles d'usage de git et les lignes d'attribution à ajouter. Les deux sont normalement déjà dans ton contexte. **Sans `WORKFLOW.md`, ne commite rien** — propose `workflow:setup`.

Identifie **les dépôts que le travail en cours a touchés**. Sur un projet qui regroupe plusieurs dépôts, ce n'est pas seulement le répertoire courant. Lis le `CLAUDE.md` de chacun : il peut porter des règles propres, comme un travail direct sur la branche principale.

## 2. Délimiter

Pour chaque dépôt, regarde l'état complet de l'arbre de travail et de l'index, puis le diff de chaque fichier modifié ou nouveau.

- **Ne commite que ce que le travail en cours a produit.** Un fichier que la conversation n'a pas touché reste hors du commit, et le compte rendu le signale. Regarde aussi l'index : une modification indexée avant toi entre dans le commit malgré un ajout ciblé — retire-la de l'index sans la perdre.
- **Un commit par sujet.** Quand le travail mêle plusieurs sujets ou plusieurs tickets, fais plusieurs commits, chacun avec ses fichiers.
- **Le message suit exactement le format de `WORKFLOW.md`**, dans sa langue, avec la référence de ticket qu'il exige. Règle-toi aussi sur les derniers commits du dépôt : portée, ton, longueur. Le sujet dit ce que fait le commit ; le corps, quand il sert, dit pourquoi. Ajoute les lignes d'attribution prévues.

## 3. S'arrêter sur un doute

Dans les cas suivants, ne commite rien dans le dépôt concerné : expose le cas et attends la réponse. Les autres dépôts se traitent normalement.

- **Un fichier relève peut-être du travail en cours, peut-être pas.** Mieux vaut une question qu'un commit qui embarque le travail de quelqu'un d'autre.
- **Le diff contient ce qui ressemble à un secret** : clé, mot de passe, jeton, chaîne de connexion, fichier d'environnement.
- **La branche courante contredit la convention** : un commit sur la branche d'intégration ou de production d'un dépôt qui travaille par branches de fonctionnalité. Un dépôt dont la documentation dit qu'il travaille directement sur sa branche principale n'est pas un écart. Quand l'historique montre cette pratique sans que la documentation la dise, demande, et propose de l'écrire dans le `CLAUDE.md` du dépôt pour que la question ne revienne pas.
- **Un hook échoue.** Corrige si la cause relève du travail en cours, sinon rends compte. Jamais `--no-verify`.
- **Le push est refusé**, ou la mise à jour de la branche produit un conflit.

## 4. Commiter et pousser

Commite, puis pousse la branche courante vers son dépôt distant, avec suivi si c'est son premier push.

**Si le distant a avancé**, mets la branche à jour selon la stratégie de `WORKFLOW.md` — rebase si rien n'est précisé — puis pousse. Seuls tes commits encore locaux sont rejoués ; rien de ce qui est déjà poussé n'est réécrit.

**Vérifie** ensuite que la branche locale est alignée sur le distant. Un push qui semble réussi ne prouve pas que les commits y sont.

## 5. Rendre compte

Par dépôt : la branche, chaque commit (hash court et message), le distant vers lequel il est poussé, et les fichiers laissés hors commit avec leur raison.

Si la branche suit le cycle d'une pull request, signale `/workflow:to-pr`. Ne touche ni au tracker ni à la pull request.

## Règles

- **Le `WORKFLOW.md`, le `CLAUDE.md` et le `README.md` du projet font foi** sur tout le reste : ils l'emportent sur les comportements par défaut de ce skill, et une règle locale se suit sans la discuter. Mais quand la contradiction est **forte** — un principe du skill et une règle du projet qui ne peuvent pas tenir ensemble —, arrête-toi, expose les deux, et demande ce qu'il faut mettre à jour : la documentation du projet, ou le skill lui-même quand la règle a vocation à valoir partout.
- **Pas de confirmation de routine.** La commande est l'accord ; seuls les doutes de la section 3 justifient une question.
- **Rien hors du travail en cours.** Ce que tu n'as pas produit ne part pas avec ton commit.
- **Aucune réécriture d'historique partagé** : pas de force push, pas d'amend d'un commit déjà poussé.
- **Ni tracker ni pull request.** Les statuts relèvent de `workflow:implement`, la pull request de `workflow:to-pr`.
