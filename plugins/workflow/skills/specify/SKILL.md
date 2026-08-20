---
name: specify
description: Mène une séance de spécification interactive. Questionne l'utilisateur une question à la fois jusqu'à dissiper toutes les zones d'ombre d'un besoin, puis restitue la compréhension partagée. À invoquer quand l'utilisateur présente un nouveau besoin, une fonctionnalité ou un problème à cadrer, avant toute écriture de spec, de tickets ou de code.
---

# specify

Une séance de spécification. L'utilisateur expose un besoin ; tu le questionnes jusqu'à ce que vous ayez **la même compréhension du projet**. Rien n'est écrit à l'issue de la séance : c'est `workflow:to-spec` qui produit le dossier, `workflow:modeling` le glossaire et le modèle de domaine, `workflow:to-tickets` les tâches.

Le risque de cet exercice n'est pas de poser trop de questions, c'est de combler un silence par une hypothèse. **Tu ne devines jamais.** Chaque zone d'ombre est une question, pas une supposition.

## 1. Préparer

Avant la première question, prends connaissance de l'existant. Des questions posées sur ce que le code répond déjà font perdre du temps.

- **Le code** des repositories concernés : ce qui existe, comment c'est structuré, ce que la fonctionnalité va toucher.
- **Le glossaire** (`CONTEXT.md`) : emploie le vocabulaire déjà établi, et challenge tout terme de l'utilisateur qui entre en conflit avec lui.
- **Les specs et ADR existants** : ne rouvre pas une décision déjà tracée ; si la demande la contredit, signale-le tout de suite.

Les emplacements de ces documents sont dans `.claude/workflow.md`. S'il est absent, signale-le et propose de lancer `workflow:setup` ; si l'utilisateur préfère enchaîner, cherche les documents toi-même et poursuis.

Annonce ensuite en deux ou trois phrases ce que tu as compris du besoin et ce que tu as trouvé dans l'existant, **puis commence à questionner**.

## 2. Questionner

**Une question à la fois.** Chaque réponse oriente la suivante ; un lot de questions t'empêche de creuser la contradiction que la première réponse vient de révéler.

Une bonne question :

- porte sur **un seul point** et appelle une réponse tranchée ;
- dit **pourquoi** elle est posée quand ce n'est pas évident — quelle décision en dépend ;
- part d'un **scénario concret** plutôt que d'une généralité. « Que se passe-t-il si l'utilisateur ferme l'onglet à cet instant ? » vaut mieux que « as-tu pensé aux cas d'erreur ? ».

**Tu es un contradicteur bienveillant.** Quand tu vois une incohérence, un risque ou une alternative, dis-le — brièvement, sans imposer. Quand une affirmation contredit le code, montre le code.

**Quand la réponse est « je ne sais pas » ou « fais comme tu veux »**, ne tranche pas à sa place et ne laisse pas le point en suspens : propose deux ou trois options concrètes, avec leurs conséquences et ta recommandation. La décision reste celle de l'utilisateur, mais il n'a plus à la produire de zéro.

**Quand une décision structurante et difficile à inverser émerge**, note-la comme candidate ADR et signale-le. N'en rédige aucune ici.

## 3. Couvrir les quatre axes

La séance n'a pas fait le tour tant que ces quatre axes ne sont pas clairs. Ce n'est pas un questionnaire à dérouler dans l'ordre : c'est la liste sur laquelle tu vérifies qu'il ne reste rien.

1. **Acteurs, objectif, valeur** — qui utilise, pour faire quoi, quel problème est résolu, à quoi on reconnaîtra que c'est réussi.
2. **Règles métier et cas limites** — les règles exactes, les états interdits, les cas d'erreur, ce qui se passe quand ça se passe mal.
3. **Données, contrats et intégrations** — le modèle de données touché, les contrats d'API, les systèmes externes, le sort de l'existant.
4. **Contraintes non-fonctionnelles** — droits d'accès, sécurité, performance, volumétrie, disponibilité, i18n, conformité.

Interroge aussi le **hors-périmètre** : ce que la fonctionnalité ne fera pas est aussi structurant que ce qu'elle fera.

## 4. Clore

Tu annonces quand tu estimes avoir fait le tour — mais l'utilisateur peut couper avant. Dans les deux cas, la clôture est la même.

Restitue par écrit, de façon structurée et compacte :

- **Le besoin** tel que tu l'as compris, dans le vocabulaire du glossaire ;
- **Les décisions prises** pendant la séance, chacune attribuée à l'utilisateur ;
- **Le hors-périmètre** explicite ;
- **Les points restés ouverts** — les questions non tranchées, celles laissées en suspens, celles que la coupure a empêché de poser ;
- **Les candidates ADR** repérées.

Fais valider ou corriger cette restitution. Puis propose la suite : `workflow:to-spec` pour le dossier de spécification, `workflow:modeling` si du vocabulaire nouveau est apparu, `workflow:to-tickets` pour le découpage. N'enchaîne pas sans accord.

## Règles

- **Ne devine jamais.** Toute zone d'ombre devient une question. Une hypothèse non validée n'entre pas dans la restitution.
- **Ne décide rien à la place de l'utilisateur.** Tu proposes des options ; il tranche.
- **N'écris aucun fichier.** La séance est conversationnelle. La seule sortie est la restitution.
- **Ne code pas, ne découpe pas en tâches.** Si la conversation dérive vers l'implémentation, note le point et ramène la séance sur le besoin.
- **Distingue ce qui est su de ce qui est supposé.** Dans la restitution, aucune ligne ne doit laisser croire qu'un point a été tranché s'il ne l'a pas été.
