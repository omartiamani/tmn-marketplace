---
name: check-pr
description: Garde-fou d'une pull request avant son passage en revue — sa description dit-elle vrai sur le code, code et description répondent-ils aux tickets associés, le code est-il bon — qui ne remonte que des problèmes avérés et propose leur correction, sans rien appliquer sans accord. À invoquer avant de marquer une pull request prête pour la revue, sur la commande /workflow:check-pr, ou quand l'utilisateur demande de vérifier une pull request.
---

# check-pr

Un garde-fou avant qu'une pull request soit marquée prête pour la revue. Son objectif : s'assurer d'une part que la pull request répond aux specs définies dans ses tickets, d'autre part que le code reflète ce que dit la pull request et qu'il est propre. Trois questions, et seulement trois :

1. **La description dit-elle vrai ?** Chaque affirmation qu'elle contient correspond au code de la pull request.
2. **Le travail répond-il aux tickets ?** Le code et la description font ce qu'attendent les tickets associés.
3. **Le code est-il bon ?** Il fonctionne, il respecte les règles écrites du projet, et ses tests protègent ce qu'il faut.

**Un garde-fou, pas une revue de plus.** Il ne remonte que des problèmes avérés — ce qui est faux, manquant ou cassé, et se démontre. Ni suggestion, ni préférence, ni détail. Une pull request sans problème est très courte.

La description est ce que lit le relecteur, et ce qu'on retrouve des mois plus tard en cherchant pourquoi le code est ainsi. Une affirmation fausse y est pire qu'une absence : on la croit.

**Seule la description fait foi.** Les messages de commit ne sont ni lus ni contrôlés.

**Tu rapportes et tu proposes ; tu n'appliques rien sans accord.**

## 1. Se situer

Prends dans `WORKFLOW.md` le format attendu du corps de pull request et de ses références aux tickets ; dans la section « Workflow tooling » du `CLAUDE.md`, les commandes pour lire et modifier une pull request. Lis le `CLAUDE.md` et le README du dépôt concerné : ce sont eux qui disent quelles règles le code doit respecter et comment lancer les contrôles. Sans `WORKFLOW.md`, signale-le et propose `workflow:setup` : le contrôle des références aux tickets devient impossible, le reste se fait.

Identifie la pull request : celle passée en argument, sinon celle de la branche courante. **Quand la même branche existe dans plusieurs dépôts**, la fonctionnalité a souvent une pull request par dépôt : contrôle chacune. Une affirmation peut porter sur l'autre dépôt — « needs the matching API changes » — : vérifie-la là-bas.

Récupère, pour chaque pull request :

- son titre et sa **description** complets ;
- son **diff complet** par rapport à la branche d'intégration — l'état final, tel qu'il sera fusionné ;
- les **tickets associés**, lus en entier, commentaires compris : ceux que la description ferme ou référence, et ceux que désigne le nom de la branche selon la convention de `WORKFLOW.md`. Remonte à leur parent et liste tous ses enfants : la pull request se juge contre l'ensemble des tickets du parent qu'elle sert, pas seulement contre ceux qu'elle cite.

## 2. Relancer les contrôles automatiques

Lance le build, le lint et la suite de tests complète du dépôt, avec les commandes du README telles que le `CLAUDE.md` dit de les lancer. Si la pull request a des contrôles automatiques sur l'outil (CI), lis aussi leur état.

Un échec n'interrompt pas le contrôle : poursuis, et place-le en tête du rapport.

## 3. Confier la lecture à un regard neuf

Les contrôles se font **dans deux subagents neufs**, lancés en parallèle — l'un pour la description et les tickets (A et B), l'autre pour le code (C) —, jamais dans le contexte qui a écrit le code ou la description. Celui qui a écrit relit son intention, pas le code.

Chaque subagent reçoit uniquement : l'identifiant de la pull request et la commande pour en lire le diff, la description, le contenu complet des tickets associés, les chemins des règles du projet à lire, la consigne de ses contrôles et le seuil de preuve ci-dessous. Ni la conversation, ni ton avis sur le code.

Pour la recherche de bugs, lance en parallèle, **pour chaque pull request**, un subagent dont la seule tâche est d'invoquer le skill de revue de code de Claude Code — `code-review`, avec l'URL de la pull request en argument, le chemin du dépôt local et les consignes d'accès du `CLAUDE.md` — puis de te renvoyer ses constats en texte, sans les trier. Invoqué depuis un subagent, ce skill s'exécute dans un contexte séparé et ne rend que ses constats ; invoqué depuis ton contexte, il s'y déroule en entier.

Si tu ne peux pas lancer de subagent, fais les contrôles toi-même et dis-le dans le rapport : la lecture n'est alors pas indépendante.

### Le seuil de preuve

Un problème ne remonte que s'il se démontre : la ligne de code, le critère du ticket ou la phrase de la description qui le prouve, et ce qui en résulte de faux. Ce qui se soupçonne sans se montrer ne remonte pas. Ce qui relève du goût, du style, d'une amélioration possible ou d'une règle qu'aucun document du projet n'écrit ne remonte pas non plus.

Avant de rapporter, repasse chaque constat des subagents et de la revue de code au crible de ce seuil : écarte ceux qui ne le franchissent pas, fusionne les doublons.

### Contrôle A — la description

Découpe la description en affirmations — chaque comportement, règle, valeur, libellé, version de dépendance, référence à un ADR, chaque « n'est plus », et chaque note au relecteur qui affirme un fait sur le code — et confronte chacune au diff. Remonte celles que le code **contredit** et celles dont il ne porte **aucune trace**. Une affirmation sur un état extérieur au code — une base de données, une vérification faite à la main — ne se juge pas.

Remonte aussi les **changements tus** : un changement de comportement, de contrat d'API, de schéma de données ou de dépendance, ou une suppression de test, présent dans le diff et absent de la description.

### Contrôle B — les tickets

- **Critères d'acceptance** — confronte au code chaque critère de chaque ticket fermé, et chaque règle métier ou cas limite qu'il écrit. Remonte ceux qui sont **absents**, **partiels** ou **contredits**.
- **Description et tickets** — remonte une affirmation de la description qui contredit un ticket, et un ticket fermé que la description ne couvre pas. Quand le code et la description s'écartent ensemble d'un ticket, ne tranche pas : donne les deux issues — corriger le code, ou mettre le ticket à jour.
- **Références** — elles suivent `WORKFLOW.md` : mot-clé de fermeture sur chaque ticket que la pull request achève, et sur eux seuls ; simple mention pour le parent. Un ticket servi par plusieurs pull requests ne se ferme que dans celle qui sera fusionnée en dernier.
- **Complétude** — une pull request ne passe en revue que lorsqu'elle porte tous les enfants du ticket qu'elle sert : remonte ceux qui manquent.

Les pistes techniques d'un ticket ne sont pas des exigences : s'en écarter n'est pas un problème.

### Contrôle C — le code

- **Règles du projet** — une règle écrite dans le `CLAUDE.md`, le README ou les règles du dépôt, enfreinte. Cite-la, avec son fichier.
- **Tests** — un critère d'acceptance qui porte une règle métier ou un cas limite, sans test qui échouerait s'il régressait.
- **Restes** — trace de débogage, secret, valeur en dur que le projet interdit.
- **Documentation** — un README, une spec, un glossaire ou un diagramme que le changement rend faux.
- **Bugs** — seulement si la revue de code n'a pas pu tourner : un scénario concret qui produit un résultat faux, un plantage ou une faille.

## 4. Rapporter

Va droit au but : ni préambule, ni liste de ce qui est conforme ou de ce qui a été vérifié.

**Sans problème**, le rapport tient en une ligne : prête pour la revue, contrôles automatiques verts.

**Sinon**, le verdict d'abord — à corriger, et le nombre de problèmes —, puis les problèmes, sous **Contrôles automatiques**, **Description**, **Tickets** et **Code** ; une rubrique sans problème n'apparaît pas. Chaque problème tient en une ou deux lignes : où — fichier et ligne, ticket et critère, ou phrase de la description —, ce qui est faux, et la correction proposée.

Pour la description ou un ticket devenu faux, la correction proposée est le passage à remplacer et son remplacement, dans la langue déclarée dans `WORKFLOW.md`. Le texte complet ne s'écrit qu'au moment d'appliquer.

## 5. Corriger, après accord

L'utilisateur choisit ce qui s'applique.

- **La description** se remplace avec la commande du `CLAUDE.md`, par le texte validé.
- **Un ticket devenu faux** se met à jour de la même façon. Jamais ses critères d'acceptance pour faire passer le code : un critère intenable se discute, il ne se réécrit pas.
- **Le code** se corrige selon `workflow:implement` : un bug corrigé commence par un test rouge qui le reproduit. Le commit suit la convention du projet, et se demande.
- Après une correction du code, **rejoue les contrôles touchés** : un correctif peut rendre fausse une phrase de la description.

Ne marque pas la pull request prête pour la revue toi-même, sauf demande explicite. Ne fusionne jamais.

## Règles

- **Le `WORKFLOW.md`, le `CLAUDE.md` et le `README.md` du projet font foi** sur tout le reste : ils l'emportent sur les comportements par défaut de ce skill, et une règle locale se suit sans la discuter. Mais quand la contradiction est **forte** — un principe du skill et une règle du projet qui ne peuvent pas tenir ensemble —, arrête-toi, expose les deux, et demande ce qu'il faut mettre à jour : la documentation du projet, ou le skill lui-même quand la règle a vocation à valoir partout.
- **Des problèmes avérés, rien d'autre.** Ce qui ne se démontre pas, ou ne relève que du goût, ne remonte pas.
- **Seule la description fait foi.** Les messages de commit ne sont pas contrôlés.
- **Le diff final, pas l'historique.** On juge ce qui sera fusionné.
- **Un regard neuf.** La lecture se fait hors du contexte qui a écrit le code ; quand c'est impossible, le rapport le dit.
- **Aucune exigence inventée.** Le code se juge contre la description, les tickets et les règles écrites du projet, pas contre tes préférences.
- **Les tickets disent l'attendu.** Entre un ticket et un code qui s'en écarte, tu ne choisis pas : l'utilisateur tranche.
- **Rien sans accord.** Ni la description, ni le code, ni un ticket — texte ou statut.
- **Un rapport honnête.** Une affirmation non vérifiée n'est pas vérifiée, et un contrôle sauté se dit.
