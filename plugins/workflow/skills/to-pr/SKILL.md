---
name: to-pr
description: Ouvre puis tient à jour la pull request d'une branche de travail — en brouillon dès le premier ticket terminé, complétée à chaque ticket suivant, passée en revue quand tous y sont — avec contrôles préalables, titre et corps composés selon la convention du projet, références aux tickets avec les bons mots-clés de fermeture. À invoquer sur la commande /workflow:to-pr ou sur demande explicite d'ouvrir ou de mettre à jour une pull request.
disable-model-invocation: true
---

# to-pr

Ouvre puis tient à jour la pull request d'une branche de travail, jusqu'à son passage en revue.

Sur beaucoup de projets, la pull request n'est pas une formalité de fin de course : son titre devient le message de commit après squash, et son corps décide de ce qui se ferme automatiquement au merge. Une référence mal formée ne se voit pas — elle ferme un ticket qui devait rester ouvert, ou laisse ouvert celui qui devait se fermer. C'est ce que ce skill sert à ne pas rater.

**Tu ouvres et tu mets à jour ; tu ne fusionnes jamais.**

## Le cycle d'une pull request

Une branche sert un ticket, souvent un parent dont les enfants se terminent un à un. Sa pull request suit ce cycle :

1. **Ouverte en brouillon dès que le premier enfant est terminé.** Le travail se voit tôt.
2. **Mise à jour à chaque enfant terminé.** Sa référence s'ajoute à ce moment-là, pas avant : sur beaucoup d'outils, lier un ticket à une pull request change son statut, et un ticket encore en cours ne doit pas paraître fini.
3. **Passée en revue quand tous les enfants y sont**, après `workflow:check-pr`.

Un ticket sans enfants parcourt le même cycle en une fois : ouverte quand il est terminé, passée en revue après `workflow:check-pr`.

Un ticket est **terminé** quand ses critères d'acceptance sont validés et son code commité.

## 1. Se situer

Prends dans `WORKFLOW.md` le format du titre, le contenu attendu du corps, les mots-clés de fermeture, la stratégie de mise à jour de branche et le mode de merge — normalement déjà dans ton contexte, importé par le `CLAUDE.md`. Sans lui, ne compose rien — propose `workflow:setup`.

Lis aussi le `CLAUDE.md` du dépôt concerné, et récupère le ou les tickets que la branche sert : identifiants, types, parents, enfants. Le nom de la branche les porte souvent.

Regarde si **la même branche existe dans d'autres dépôts** : la fonctionnalité a alors une pull request par dépôt, et un même ticket peut être servi par plusieurs d'entre elles. Pour chaque ticket, note quels dépôts portent une partie de son code.

Établis **où en est le cycle** : la pull request de la branche existe-t-elle déjà, quels enfants sont terminés, lesquels sont déjà référencés dans son corps. Ce qui est terminé ne se lit pas toujours dans le tracker : quand la conversation ne l'établit pas, demande.

## 2. Contrôler avant d'ouvrir ou de mettre à jour

Trois vérifications, dans cet ordre. Si l'une échoue, **arrête-toi et rends compte** — n'ouvre pas une pull request qu'il faudra corriger ensuite.

1. **Rien ne traîne** : l'arbre de travail est propre et la branche locale est poussée. Une modification non commitée est du travail que le relecteur ne verra pas.
2. **La branche est à jour** par rapport à la branche d'intégration. Si elle a avancé, applique la stratégie déclarée dans `WORKFLOW.md` — si pas précisé, rebase. Ne réécris jamais l'historique d'une branche déjà partagée sans une demande de validation préalable.
3. **Les tests et le build passent.** Relance-les : découvrir l'échec dans la CI coûte un aller-retour de plus, et un relecteur notifié pour rien.

## 3. Composer

**Le titre** suit exactement le format déclaré dans `WORKFLOW.md` — souvent un message de commit conventionnel, avec un scope qui référence le ticket. Il décrit ce que _ce dépôt_ fait, pas l'objectif général du ticket, dont plusieurs dépôts peuvent partager le nom de branche.

**Le corps** contient deux choses :

- **Les références exigées par la convention**, avec le bon comportement pour chacune. C'est le point le plus piégeux : sur la plupart des projets, certaines références **ferment** leur ticket au merge et d'autres doivent délibérément ne pas le faire — un ticket parent, ou un ticket transverse que cette pull request ne suffit pas à achever. Recopie la convention à la lettre ; en cas de doute sur une référence, laisse-la sans mot-clé de fermeture et signale-le. Un enfant pas encore terminé n'a pas de référence.

  **Un ticket servi par plusieurs pull requests ne se ferme que dans une seule** : aucune ne l'achève seule. Le mot-clé de fermeture va dans celle qui sera fusionnée en dernier — en général le dépôt qui consomme les autres, l'application plutôt que l'API qu'elle appelle ; si l'ordre n'est pas évident, demande. Les autres le référencent sans mot-clé de fermeture et nomment la pull request qui le ferme. Sinon, la première fusionnée ferme le ticket alors qu'une partie de son code n'est pas livrée.

- **Un résumé court du travail réel**, tiré des commits de la branche : ce qui change, et ce qui mérite l'œil du relecteur. Pas un journal commit par commit.

**À chaque mise à jour, recompose le corps entier** : les références des enfants nouvellement terminés s'ajoutent, et le résumé décrit l'état actuel de la branche, pas la suite des mises à jour. Une phrase que le dernier travail a rendue fausse disparaît.

Rédige dans la langue déclarée dans `WORKFLOW.md`.

## 4. Ouvrir ou mettre à jour

Ouvre la pull request en brouillon, ou remplace son corps, sans attendre d'accord. Puis donne son URL et montre le titre et le corps — pour une mise à jour, ce qui a changé.

**Quand tous les enfants y sont**, lance `workflow:check-pr` et traite son rapport. Une fois le rapport sans problème, propose de marquer la pull request prête pour la revue, et ne le fais qu'après accord.

**Ne touche pas au tracker.** Les références font leur travail par les automatisations de l'outil ; les tickets qui se ferment à la main ne relèvent pas de ce skill. Ne change aucun statut.

**Ne fusionne pas**, sauf si tu as l'accord explicite.

## Règles

- **Le `WORKFLOW.md`, le `CLAUDE.md` et le `README.md` du projet font foi** sur tout le reste : ils l'emportent sur les comportements par défaut de ce skill, et une règle locale se suit sans la discuter. Mais quand la contradiction est **forte** — un principe du skill et une règle du projet qui ne peuvent pas tenir ensemble —, arrête-toi, expose les deux, et demande ce qu'il faut mettre à jour : la documentation du projet, ou le skill lui-même quand la règle a vocation à valoir partout.
- **Aucune fermeture par défaut.** Un mot-clé de fermeture ne s'ajoute que si la convention le prévoit pour ce type de ticket. Dans le doute, on n'en met pas : rouvrir un ticket fermé à tort coûte plus que fermer à la main.
- **Aucune réécriture d'historique** sur une branche partagée : pas de force push, pas d'amend d'un commit déjà poussé.
- **Une branche, une pull request** par dépôt. Si la branche mélange plusieurs sujets, dis-le plutôt que de composer un titre qui les recouvre tous.
- **Pas de passage en revue sans contrôle.** Avant qu'une pull request soit marquée prête pour la revue, lance `workflow:check-pr` et traite son rapport.
