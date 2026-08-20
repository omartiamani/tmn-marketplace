---
name: to-spec
description: Rédige le dossier de spécification d'un besoin à partir de la discussion en cours, d'un ticket ou de notes, en n'y écrivant que ce qui a été réellement décidé. À invoquer après une séance de spécification, ou quand l'utilisateur demande de formaliser, rédiger ou mettre à jour une spec.
---

# to-spec

Transforme ce qui a été discuté en un document de spécification. **Tu ne spécifies pas ici, tu retranscris** : aucune question d'interview, aucune décision nouvelle. La séance de questionnement, c'est `workflow:specify`.

La valeur de ce document tient entièrement à une chose : un lecteur doit pouvoir s'y fier. Une seule règle inventée qui s'y glisse et il devient une source de vérité empoisonnée, indiscernable du reste.

## 1. Rassembler la matière

- **La conversation en cours** — le cas nominal, la séance qui vient d'avoir lieu.
- **Un ticket, un fichier ou des notes** passés en argument — récupère le contenu complet, commentaires inclus.
- **Le code existant** — relis-le pour vérifier la cohérence de ce qui a été dit, jamais pour compléter ce qui n'a pas été dit.

**Si la matière est trop mince pour produire une spec honnête, ne l'écris pas.** Dis ce qui manque et propose une séance `workflow:specify`. Un document creux coûte plus cher que pas de document.

## 2. Situer le fichier

L'emplacement des specs est dans `.claude/workflow.md`. S'il n'y figure pas, propose `docs/specs/` du repository concerné — ou du repository de documentation quand le sujet est transverse — et propose de l'inscrire dans `workflow.md` pour les fois suivantes.

Un fichier par sujet : `<emplacement>/<sujet-en-kebab-case>.md`.

**Si une spec existe déjà pour ce sujet, demande** avant d'écrire : mise à jour du fichier existant, ou nouvelle version à côté ? Ne tranche pas seul.

## 3. Rédiger

Traite les notions ci-dessous **dans cet ordre**, et uniquement celles pour lesquelles la discussion a produit de la matière. Ce n'est pas un questionnaire à remplir : une notion sans matière ne donne pas une section vide, elle ne donne pas de section du tout.

- **Le problème**, du point de vue de celui qui le subit — pas la solution.
- **L'objectif et la valeur** : ce que ça permet, et à quoi on reconnaîtra que c'est réussi.
- **Les acteurs** : qui, avec quels droits, dans quel contexte.
- **Les workflows** : quand un enchaînement d'étapes, un parcours ou un cycle de vie a été décrit, restitue-le pas à pas — les étapes, leurs conditions de passage, les états, qui déclenche quoi, et ce qui se produit quand une étape échoue ou est abandonnée. Un diagramme Mermaid est le bon outil dès que l'enchaînement se ramifie, à condition qu'il n'encode que des étapes réellement discutées.
- **Les règles métier** : les règles exactes, une par une, les états interdits, les cas limites et les cas d'erreur avec le comportement attendu.
- **Les données, contrats et intégrations** : modèle de données touché, contrats d'API, systèmes externes, sort des données existantes.
- **Les contraintes non-fonctionnelles** : droits, sécurité, performance, volumétrie, disponibilité, i18n, conformité.
- **Le hors-périmètre** : ce que la fonctionnalité ne fera pas, et pourquoi.
- **Les décisions** : chacune avec sa raison et, quand elles ont été évoquées, les alternatives écartées. Signale celles qui sont structurantes et difficiles à inverser comme candidates ADR.
- **Les points ouverts** : ce qui n'a pas été tranché, ce que ça bloque, qui doit trancher.

**Niveau de détail : les décisions, pas l'implémentation.** Les modules touchés, les contrats d'API, les changements de schéma, les interactions : oui. Les chemins de fichiers et les extraits de code : non, ils périment en quelques jours. Exception : un schéma, un type ou une machine à états qui encode une décision plus précisément que ne le ferait une phrase.

**Ni user stories ni critères d'acceptance.** C'est le rôle de `workflow:to-tickets`, qui les produira à partir de cette spec. Ne duplique pas.

Emploie le vocabulaire du glossaire (`CONTEXT.md`). Si un terme nouveau est apparu pendant la discussion, signale-le et propose `workflow:modeling` — ne l'inscris pas au glossaire depuis ici.

## 4. Restituer

Annonce le fichier écrit, et **liste séparément** :

- ce qui a été marqué comme déduit du code et reste à confirmer ;
- les points ouverts ;
- les décisions structurantes repérées comme candidates ADR.

## Règles

- **Interdiction totale d'ajout.** Aucune règle métier, aucun cas limite, aucune contrainte qui n'ait été explicitement énoncé. Même si l'omission te paraît être un oubli évident, même si la spec en paraît incomplète : tu le signales dans ta réponse, **jamais dans le fichier**.
- **Marque ce qui vient du code.** Tout ce que tu tires de ta lecture du code plutôt que de la discussion se termine par `[déduit du code — à confirmer]`. Un lecteur doit distinguer d'un coup d'œil ce qui a été décidé de ce qui a été observé.
- **La section « Points ouverts » est obligatoire.** C'est la seule qui ne se supprime jamais, même sans matière : écris alors explicitement qu'aucun point n'est ouvert à cette date. Une absence de section laisserait croire à un oubli.
- **Ne comble jamais un silence.** Une zone non discutée va dans les points ouverts, pas dans une hypothèse rédigée au présent de l'indicatif.
- **Aucune forme imposée.** Les notions ci-dessus fixent l'ordre et le contenu, pas le nombre de titres ni leur formulation. Ajuste la structure au sujet.
- **Éclate le fichier quand une section devient ingérable** — quand elle ne se relit plus d'un trait ou mérite sa propre discussion. Le fichier principal garde alors le sommaire et renvoie vers les fichiers sortis. Signale l'éclatement.
