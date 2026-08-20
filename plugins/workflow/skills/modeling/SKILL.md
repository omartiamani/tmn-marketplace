---
name: modeling
description: Maintient le modèle de domaine du projet — le glossaire CONTEXT.md et les ADR. À invoquer quand un terme métier nouveau ou flou apparaît, quand un mot est employé dans un sens qui contredit le glossaire, quand deux mots désignent visiblement la même chose, quand une décision structurante et difficile à inverser est prise, ou sur demande de glossaire ou d'ADR.
---

# modeling

Le projet a besoin d'un vocabulaire commun et d'une trace de ses décisions structurantes. Ce skill porte les deux : le glossaire `CONTEXT.md` et les ADR.

**Pourquoi c'est important.** Face à un terme ambigu, une IA ne bute pas : elle tranche silencieusement, souvent dans le sens générique plutôt que celui du métier — et le code produit compile, se lit bien, et modélise le mauvais concept. Un terme arrêté fixe ce sens une fois pour toutes : plus besoin de le redéfinir à chaque session, ni de saturer le contexte en re-explications. Il devient le nom réel de la chose dans le code, les tickets et les tests.

`CONTEXT.md` est **un glossaire, rien d'autre**. Pas une spec, pas un bloc-notes, pas un dépôt de décisions d'implémentation. Dès qu'on y écrit comment quelque chose fonctionne, il cesse d'être consultable d'un coup d'œil et personne ne le lit plus.

## Emplacement

`.claude/workflow.md` dit où vivent le glossaire et les ADR. S'il ne le dit pas, propose un `CONTEXT.md` unique dans le repository de documentation — le vocabulaire métier est transverse, un glossaire par repo laisse le même terme diverger d'un repo à l'autre — et propose d'inscrire l'emplacement dans `workflow.md`.

Crée les fichiers paresseusement : le `CONTEXT.md` à la première définition arrêtée, le répertoire d'ADR au premier ADR.

## Pendant la discussion

Trois situations te font intervenir sans qu'on te le demande.

**Un terme entre en conflit avec le glossaire.** Signale-le sur-le-champ : « le glossaire définit _Bail_ comme X, tu sembles désigner Y — lequel est-ce ? » Un désaccord de vocabulaire non tranché produit du code qui ment.

**Un terme métier est nouveau ou flou.** Quand un concept du domaine apparaît sans définition arrêtée, ou que deux mots désignent visiblement la même chose, propose un terme canonique et fais-le trancher. Éprouve la frontière avec un scénario concret plutôt qu'avec une définition abstraite : c'est le cas limite qui révèle si deux concepts n'en font qu'un.

**Une décision structurante est prise.** Repère-la et propose un ADR — voir le seuil plus bas.

## Écrire le glossaire

Le fichier contient **les termes du domaine, leurs définitions, et les relations entre eux** : un Bail porte des Lots, un Lot appartient à un Immeuble. Une définition tient en une ou deux phrases et dit ce que la chose **est**, pas ce qu'elle fait.

N'inscris que ce qui est **spécifique au domaine du projet**. Les notions techniques générales — cache, retry, DTO, idempotence — n'y ont pas leur place, même très employées. Avant d'ajouter un terme : est-ce un concept propre à ce métier, ou un concept d'informatique générale ?

Deux régimes, à ne pas confondre :

- **Ajout d'un terme nouveau** — annonce le terme et la définition que tu inscris, puis écris. Pas d'attente.
- **Modification ou suppression d'une définition existante** — montre l'ancienne et la nouvelle, et **attends l'accord**. Quelqu'un a déjà écrit du code sur la foi de l'ancienne définition.

**Rédige dans la langue déclarée dans `.claude/workflow.md`**, quelle que soit la langue de la conversation.

Écris au fil de l'eau, dès qu'un terme est tranché. Ne mets pas en file d'attente : ce qui est reporté en fin de séance est perdu.

## Quand le code contredit le glossaire

Montre les deux — la définition et ce que fait réellement le code — et demande lequel fait foi. Selon la réponse : tu corriges la définition, ou tu ouvres une tâche de renommage. **Tu ne renommes rien toi-même**.

## Écrire un ADR

Un ADR se justifie quand **les trois** conditions sont réunies :

1. la décision est **difficile à inverser** — le coût de changer d'avis plus tard est réel ;
2. **plusieurs options crédibles** ont été pesées ;
3. le **pourquoi** sera oublié dans six mois.

C'est rare par construction. Une décision qui ne remplit pas les trois n'est pas un ADR : elle va dans la spec ou dans le ticket. Ne transforme pas le répertoire d'ADR en journal de bord.

Un ADR porte un numéro séquentiel, un titre qui énonce la décision (`0003-cosmos-db-comme-magasin-de-baux.md`), et contient :

- **Statut** — proposé, accepté, ou remplacé par l'ADR n° X ;
- **Contexte** — la situation et les contraintes qui rendent la décision nécessaire ;
- **Décision** — ce qui est décidé, formulé à la voix active ;
- **Alternatives écartées** — celles qui ont été réellement pesées, et pourquoi elles ne l'emportent pas ;
- **Conséquences** — ce que la décision rend possible, et ce qu'elle coûte.

**Un ADR accepté ne se réécrit pas.** Quand la décision change, écris un nouvel ADR et marque l'ancien comme remplacé. L'historique des décisions a autant de valeur que la décision courante.

Fais valider le contenu avant d'écrire un ADR : contrairement à un ajout de terme, c'est un document qui engage.

## Règles

- **Le glossaire est un glossaire.** Aucune règle métier, aucun détail d'implémentation, aucune décision. Ces choses vont dans la spec, le ticket ou l'ADR.
- **Sois tranché.** Quand plusieurs mots désignent la même chose, retiens-en un et note les autres comme à éviter. Un glossaire qui n'arbitre pas ne sert à rien.
- **Ne définis jamais un terme à la place de l'utilisateur.** Tu proposes une définition, il la valide ou la corrige.
- **Reste bref.** Ce fichier est lu en entier par chaque session qui touche au domaine : chaque phrase superflue se paie à chaque fois.
