---
name: implement
description: Implémente une tâche identifiée par son numéro en TDD strict — red, green, refactor — en gérant sa branche, son statut dans le gestionnaire de projet et la mise à jour de la documentation devenue fausse. À invoquer quand l'utilisateur demande d'implémenter, de développer ou de corriger un work item désigné par son identifiant.
---

# implement

Implémente **une** tâche, désignée par son identifiant, en test-driven development.

Le ticket fait loi. Il a été rédigé comme un instantané de ce qui était valable à sa création : c'est lui qui définit le périmètre, pas ce que le code te suggère en chemin.

## 1. Prendre connaissance

Lis `.claude/workflow.md` — statuts, transitions, conventions de branche et de commit, emplacements documentaires. Sans lui, ne démarre pas : propose `workflow:setup`.

Récupère le work item par son identifiant et lis-le **en entier**, commentaires compris. Puis :

- vérifie ses **dépendances bloquantes** — si un bloqueur n'est pas terminé, signale-le et demande avant de continuer ;
- lis la **spec** dont il est issu et le **glossaire**, pour employer les bons termes ;
- lis le **code** concerné, et repère les tests existants qui couvrent la zone ;
- lis le **`CLAUDE.md` du dépôt** que tu vas modifier, et son README. Le README dit quelles commandes existent, le `CLAUDE.md` dit comment les lancer et ce qu'il ne faut surtout pas faire — gestionnaire de paquets imposé, commande interdite, valeur à ne jamais inscrire en dur. Sur un projet regroupant plusieurs dépôts, celui du dépôt cible n'est pas chargé automatiquement : va le lire.

## 2. Présenter le plan

Avant d'écrire quoi que ce soit, expose : ta compréhension du ticket, les critères d'acceptance tels que tu les as compris, les fichiers et modules que tu comptes toucher, et la suite de tests que tu vas écrire — dans quel ordre.

**Attends le feu vert.** C'est le seul arrêt imposé du cycle ; il vaut mieux corriger un malentendu ici qu'après trois cycles rouges.

## 3. Démarrer

Passe le ticket au statut « en cours » défini par `workflow.md`, et **crée la branche** selon la convention du projet. Ces deux gestes ne demandent pas d'accord.

Ne te dispense de la branche que si la documentation du dépôt dit qu'il travaille directement sur sa branche principale — c'est le cas courant d'un dépôt de documentation ou de scripts, ni construit ni déployé. Suis-la sans la discuter : ce n'est pas un écart à signaler.

## 4. Red, green, refactor

Un comportement à la fois, strictement :

**Red.** Écris un test qui décrit le comportement attendu, et **exécute-le pour montrer qu'il échoue**. Un test qui passe du premier coup ne prouve rien — soit il ne teste pas ce que tu crois, soit le comportement existe déjà. Dans les deux cas, arrête-toi et comprends pourquoi avant de continuer.

**Green.** Écris le code **minimal** qui fait passer le test. Pas la généralisation que tu anticipes, pas le cas suivant : juste celui-ci.

**Refactor.** Une fois au vert, améliore la structure — du code comme des tests — en gardant la suite verte. Puis passe au comportement suivant.

Ne saute jamais l'étape rouge, y compris pour une correction de bug : le test qui reproduit le bug doit d'abord échouer, sinon rien ne prouve qu'il l'attrape.

Teste le **comportement observable**, pas les détails d'implémentation : un test qui casse à chaque refactor sans qu'aucun comportement ne change est un test à réécrire.

**N'écris pas un test pour avoir écrit un test.** Un test se justifie par le comportement qu'il protège. Une fonction qui ne fait qu'encapsuler un appel de bibliothèque, un accesseur, une fonction d'une ligne sans branche : les tester ne protège de rien et transforme chaque refactor en corvée. Teste ce qui porte une règle métier, un cas limite, une décision. En cas de doute, demande-toi ce qu'un test attraperait qu'une relecture n'attraperait pas — si la réponse est « rien », ne l'écris pas.

Les commandes de test et de build se trouvent dans le README du repository, et la façon de les lancer dans son `CLAUDE.md` — les deux se lisent, jamais l'un sans l'autre. **Si les commandes ne sont pas dans le README, propose de les y ajouter** — un développeur qui arrive sur le projet doit les y trouver, ce n'est pas une information réservée à l'outillage.

## 4 bis. Les tâches d'infrastructure

L'infrastructure as code ne se fait pas en TDD : il n'y a pas de test unitaire à faire échouer avant de déclarer une ressource. Suis la boucle de [INFRA.md](./INFRA.md) — plan, validation, déploiement, vérification chez le fournisseur.

## 5. Quand la réalité s'écarte du ticket

Tout ce que tu écris — message de commit, description, documentation — l'est **dans la langue déclarée dans `.claude/workflow.md`**, quelle que soit la langue de la conversation.

**La description du ticket est devenue fausse ou incomplète** — le comportement décrit ne correspond plus au besoin, un critère est ambigu, une contrainte a changé. Montre l'écart, propose le **texte exact** de la nouvelle description, et écris-la après accord.

**La documentation existante est devenue fausse** — README, spec, diagramme, glossaire. Même procédure : l'écart, le texte proposé, l'accord, puis l'écriture. Ne laisse pas derrière toi une doc que ton propre travail vient de démentir.

**Le travail déborde du ticket.** Reste strictement dans le périmètre. Note ce que tu as découvert, et signale-le dans ton compte rendu en proposant d'en faire un ticket. N'élargis pas, même pour un ajout qui paraît minime : c'est ainsi qu'une tâche d'une session en devient trois.

## 6. Terminer

Avant d'annoncer quoi que ce soit, vérifie — et montre les résultats :

- la **suite de tests complète** du repository est au vert, pas seulement tes tests ;
- le **lint et le build** passent ;
- **chaque critère d'acceptance** est repris un par un, avec ce qui le prouve ;
- le comportement est **constaté dans l'application réelle**.

Ce dernier point n'est pas une formalité : les tests prouvent que le code fait ce que tu as écrit, pas que la fonctionnalité marche. Vérifie selon ce que la tâche touche.

- **Front et back** — démarre les serveurs locaux comme l'indique le README, ouvre le parcours concerné et constate le comportement de bout en bout, y compris le cas d'erreur. Si l'application a une page de connexion, **demande à l'utilisateur de s'authentifier lui-même** : tu ne saisis jamais ses identifiants.
- **API seule** — fais de vrais appels **authentifiés**, et examine les réponses réelles : code de statut, corps, en-têtes. Vérifie aussi le refus attendu — appel non authentifié, droit insuffisant, entrée invalide.
- **Interface seule** — parcours l'écran dans le navigateur, y compris les états vide, de chargement et d'erreur.
- **Infrastructure** — voir [INFRA.md](./INFRA.md).

**Les appels réels se font en environnement local ou de développement, jamais ailleurs.** Vérifie sur quel environnement tu pointes avant le premier appel ; dans le doute, demande. Aucune vérification ne justifie de toucher à un environnement de recette ou de production.

**Quand un appel de vérification mute des données** — création, modification, suppression — annonce-le avant, et **demande une fois les vérifications terminées s'il faut revenir en arrière**. Même en développement, des données laissées derrière faussent le travail suivant. Ne supprime jamais de ta propre initiative.

Si l'un de ces contrôles échoue, dis-le tel quel avec la sortie obtenue. Une tâche n'est pas terminée parce que le code est écrit, ni parce que les tests sont verts.

Puis, dans cet ordre, en demandant à chaque fois :

1. **Commiter** — message selon la convention du projet, référençant le work item.
2. **Passer le ticket au statut suivant** — celui défini par `workflow.md`.

Le push et la pull request restent à la main de l'utilisateur, sauf demande explicite.

## Règles

- **La documentation du projet fait foi.** Quand un `CLAUDE.md`, un README ou la documentation de workflow contredit un comportement par défaut de ce skill, c'est elle qui l'emporte — sans discussion, et sans la traiter comme une divergence.
- **Une tâche à la fois.** Si le ticket s'avère trop gros pour une session, dis-le et propose de le scinder plutôt que de le dérouler à moitié.
- **Aucun code de production sans test rouge d'abord.** Sans exception, correction de bug comprise — hors infrastructure, qui suit la boucle de la section 4 bis.
- **Un test doit valoir son coût.** Pas de test sur du code trivial ou sur un simple passe-plat vers une bibliothèque.
- **Ne modifie pas les critères d'acceptance pour les faire passer.** Si un critère est intenable, c'est une discussion, pas une réécriture.
- **Ne rends jamais un compte rendu optimiste.** Un test ignoré, une vérification sautée, un critère non couvert : ça se dit.
- **Ne ferme pas le parent.** Seul le work item traité change de statut.
