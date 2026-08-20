# Tâches d'infrastructure

L'infrastructure as code ne se prête pas au cycle rouge-vert : il n'y a pas de test unitaire à faire échouer avant de déclarer une ressource. La boucle de vérification est différente, mais elle est tout aussi contraignante.

1. **Écris la déclaration**, puis lance la validation et le **plan**. Lis-le en entier : ce qui est créé, modifié, et surtout **détruit**. Un plan qui contient une destruction non prévue au ticket s'arrête là et se signale.
2. **Fais valider le plan** avant tout déploiement. Un déploiement d'infrastructure n'est pas une opération réversible d'un coup d'annulation.
3. **Déploie sur l'environnement de développement uniquement**, sauf instruction explicite portant sur un autre environnement. Vérifie sur quel abonnement et quel environnement tu pointes avant d'appliquer.
4. **Après déploiement, vérifie que la ressource existe réellement** et qu'elle est configurée comme attendu — interroge le fournisseur, pas le fichier d'état : c'est le monde réel qui fait foi, pas la déclaration.
5. **Vérifie ce qui consomme la ressource** quand il y en a : une connexion établie, un secret lisible, un droit effectif.

Rends compte du plan appliqué et de ce que la vérification a constaté, ressource par ressource.
