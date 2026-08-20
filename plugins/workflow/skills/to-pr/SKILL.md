---
name: to-pr
description: Ouvre la pull request d'une branche de travail — contrôles préalables, titre et corps composés selon la convention du projet, références aux tickets avec les bons mots-clés de fermeture. À invoquer sur la commande /workflow:to-pr ou sur demande explicite d'ouvrir une pull request.
disable-model-invocation: true
---

# to-pr

Compose et ouvre la pull request d'une branche de travail.

Sur beaucoup de projets, la pull request n'est pas une formalité de fin de course : son titre devient le message de commit après squash, et son corps décide de ce qui se ferme automatiquement au merge. Une référence mal formée ne se voit pas — elle ferme un ticket qui devait rester ouvert, ou laisse ouvert celui qui devait se fermer. C'est ce que ce skill sert à ne pas rater.

**Tu ouvres, tu ne fusionnes jamais.**

## 1. Se situer

Lis `.claude/workflow.md` : format du titre, contenu attendu du corps, mots-clés de fermeture, stratégie de mise à jour de branche, mode de merge. Sans lui, ne compose rien — propose `workflow:setup`.

Lis aussi le `CLAUDE.md` du dépôt concerné, et récupère le ou les tickets que la branche sert : identifiants, types, parents. Le nom de la branche les porte souvent.

## 2. Contrôler avant d'ouvrir

Trois vérifications, dans cet ordre. Si l'une échoue, **arrête-toi et rends compte** — n'ouvre pas une pull request qu'il faudra corriger ensuite.

1. **Rien ne traîne** : l'arbre de travail est propre et la branche locale est poussée. Une modification non commitée est du travail que le relecteur ne verra pas.
2. **La branche est à jour** par rapport à la branche d'intégration. Si elle a avancé, applique la stratégie déclarée dans `workflow.md` — si pas précisé, rebase. Ne réécris jamais l'historique d'une branche déjà partagée sans une demande de validation préalable.
3. **Les tests et le build passent.** Relance-les : découvrir l'échec dans la CI coûte un aller-retour de plus, et un relecteur notifié pour rien.

## 3. Composer

**Le titre** suit exactement le format déclaré dans `workflow.md` — souvent un message de commit conventionnel, avec un scope qui référence le ticket. Il décrit ce que _ce dépôt_ fait, pas l'objectif général du ticket, dont plusieurs dépôts peuvent partager le nom de branche.

**Le corps** contient deux choses :

- **Les références exigées par la convention**, avec le bon comportement pour chacune. C'est le point le plus piégeux : sur la plupart des projets, certaines références **ferment** leur ticket au merge et d'autres doivent délibérément ne pas le faire — un ticket parent, ou un ticket transverse que cette pull request ne suffit pas à achever. Recopie la convention à la lettre ; en cas de doute sur une référence, laisse-la sans mot-clé de fermeture et signale-le.
- **Un résumé court du travail réel**, tiré des commits de la branche : ce qui change, et ce qui mérite l'œil du relecteur. Pas un journal commit par commit.

Rédige dans la langue déclarée dans `workflow.md`.

## 4. Ouvrir

Montre le titre et le corps complets, et **attends l'accord** avant d'ouvrir. Puis ouvre la pull request et donne son URL.

**Ne touche pas au tracker.** Les mots-clés de fermeture feront leur travail au merge ; les tickets qui se ferment à la main ne relèvent pas de ce skill. Ne change aucun statut.

**Ne fusionne pas**, sauf si tu as l'accord explicite.

## Règles

- **La documentation du projet fait foi.** Une convention écrite dans un `CLAUDE.md`, un README ou la documentation de workflow l'emporte sur tout défaut de ce skill.
- **Aucune fermeture par défaut.** Un mot-clé de fermeture ne s'ajoute que si la convention le prévoit pour ce type de ticket. Dans le doute, on n'en met pas : rouvrir un ticket fermé à tort coûte plus que fermer à la main.
- **Aucune réécriture d'historique** sur une branche partagée : pas de force push, pas d'amend d'un commit déjà poussé.
- **Une branche, une pull request.** Si la branche mélange plusieurs sujets, dis-le plutôt que de composer un titre qui les recouvre tous.
