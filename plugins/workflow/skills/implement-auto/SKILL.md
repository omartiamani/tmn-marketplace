---
name: implement-auto
description: Variante autonome de workflow:implement — implémente une tâche et toutes ses tâches enfants en TDD, sans solliciter l'utilisateur, puis commite et pousse la branche. Ne jamais déclencher de soi-même : uniquement sur la commande /workflow:implement-auto ou sur une demande explicite de travailler en autonomie.
disable-model-invocation: true
---

# implement-auto

La variante autonome de `workflow:implement`. **Applique [le skill workflow:implement](../implement/SKILL.md) en entier** — cycle red-green-refactor, valeur des tests, vérification dans l'application réelle, boucle d'infrastructure — avec les seules différences décrites ici.

Ce skill ne se déclenche jamais de lui-même : il faut la commande `/workflow:implement-auto` ou une demande explicite de travailler sans validation. Dans le doute, c'est `workflow:implement` qui s'applique.

L'autonomie porte sur les validations, pas sur la rigueur. Rien de ce qui protège la qualité ne saute : ce sont les allers-retours qui sautent.

## Ce qui change

**Pas de plan à faire valider.** Annonce ta compréhension du ticket et ton approche, puis enchaîne directement.

**Périmètre : la tâche et toutes ses tâches enfants.** Récupère l'arborescence complète sous l'identifiant fourni et déroule-la dans l'ordre des dépendances bloquantes. Une tâche par cycle complet, terminée et vérifiée avant de passer à la suivante.

**Les ambiguïtés se tranchent seul.** Retiens l'hypothèse la plus raisonnable au vu de la spec, du glossaire et du code existant. **Documente-la à deux endroits** : dans le corps du commit concerné, et dans le compte rendu final, sous une rubrique distincte. Une décision prise en ton absence doit être visible sans lire le code.

**Les corrections de documentation s'écrivent directement.** README, spec, diagramme, glossaire : corrige sans demander, et liste chaque modification dans le compte rendu.

**En revanche, ne touche à aucun work item.** Si la description d'une tâche est devenue fausse ou incomplète, ne la réécris pas : rapporte l'écart et la correction que tu proposes dans le compte rendu. Seul le statut « en cours » des tâches du périmètre est modifié — rien d'autre.

**Le débordement mineur se traite**, à trois conditions cumulatives : il est directement lié à la tâche, il ne change aucun contrat public ni schéma de données, et il tient en un cycle. Sinon, reste dans le périmètre et signale-le. En cas de doute, c'est que ce n'est pas mineur.

**Les vérifications qui exigent un humain se contournent ou se sautent.** Utilise ce qui est automatisable — compte de test, jeton de développement déjà configuré. Si l'accès est impossible, **saute la vérification et dis-le explicitement** ; ne la déclare jamais faite. Les données mutées pendant les vérifications restent en place : liste-les dans le compte rendu au lieu de les supprimer.

**Git.** Un commit par cycle vert, message selon la convention du projet et référence au work item. Pousse la branche à la fin. **N'ouvre pas de pull request** sans demande explicite.

**Statuts.** Passe chaque tâche au statut « en cours » à son démarrage. **Ne pousse aucune transition finale** : la clôture appartient à la revue humaine.

## Quand s'arrêter quand même

L'autonomie ne va pas jusqu'à livrer du rouge. Arrête-toi, laisse le dépôt dans un état propre et rends compte si :

- la suite de tests, le lint ou le build ne passent pas et que tu ne parviens pas à les remettre au vert ;
- une dépendance bloquante n'est pas terminée ;
- une limite absolue ci-dessous est atteinte ;
- la tâche s'avère reposer sur une compréhension du besoin manifestement fausse — pas une ambiguïté, une contradiction.

Un arrêt honnête à mi-parcours vaut mieux qu'un compte rendu qui déclare terminé ce qui ne l'est pas.

## Limites absolues

Aucune autonomie ne les lève :

- **Rien hors local ou développement** — aucun appel, déploiement ou migration sur un autre environnement.
- **Aucune suppression** de données ou de ressources, y compris le nettoyage après vérification et tout plan d'infrastructure qui détruit.
- **Aucune réécriture d'historique git** — pas de force push, pas de rebase de branche partagée, pas d'amend d'un commit déjà poussé.
- **Aucune modification de work item** — ni description, ni champ, ni commentaire, y compris sur les tâches du périmètre. Le seul changement autorisé est le passage au statut « en cours » des tâches traitées.

## Compte rendu final

En une seule fois, à la fin : les tâches traitées et leur état, les décisions prises en autonomie, les fichiers de documentation modifiés, les vérifications sautées et pourquoi, les données laissées en place, le débordement rencontré, et la branche poussée.
