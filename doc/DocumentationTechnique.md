## Documentation technique

Dernière mise à jour : 23/10/2025

## But et périmètre

L'application "rangement" est une application Flutter multi-plateforme (Android, iOS, Windows, macOS, Linux, Web) organisée selon une séparation claire entre la couche de présentation (`lib/presentation`), la couche métier/données (`lib/core`, `lib/data`) et les ressources générées (`lib/generated`).

Contrat minimal (inputs / outputs, modes d'erreur) :
- Entrées : actions UI (touch, tap), entrées utilisateur, lecture depuis la base locale.
- Sorties : écrans Flutter, persistance locale (SQLite / DAO), logs.
- Modes d'erreur : erreurs d'I/O (disk full, permissions), erreurs DB (migration manquante), erreurs réseau (si futures syncs).

## Arborescence

- `lib/`
	- `main.dart` : point d'entrée.
	- `core/` : providers, states, utils.
	- `data/` : DAO, DB, models.
	- `presentation/` : écrans et widgets.
	- `generated/` : fichiers générés (localisations, clés).
- `assets/` : ressources statiques, `translations/` contient `fr.json`.
- `android/`, `ios/`, `windows/`, `linux/`, `macos/`, `web/` : plateformes natives.
- `doc/` : documentation (ce fichier).

## Architecture

- Pattern appliqué : séparation en couches (presentation / domain-lite / data). Utilisation de providers pour la gestion d'état (`core/providers`).
- Persistance : les DAO se trouvent dans `lib/data/dao` et une base locale `sqflite` est utilisée
- Internationalisation : fichiers JSON dans `assets/translations/`, génération des clés dans `lib/generated/locale_keys.g.dart`.

## Dépendances

Les dépendances sont déclarées dans `pubspec.yaml`. Avant toute compilation, exécuter `flutter pub get` pour installer les paquets.

## Build et exécution

Commands courantes (à lancer depuis la racine du projet) :

```powershell
# Récupérer les dépendances
flutter pub get

# Lancer l'application sur l'émulateur ou appareil connecté (choisir un device avec flutter devices)
flutter run

# Construire un release Android
flutter build apk --release

# Construire pour Web
flutter build web
```

## Base de données

### Schéma
- House(**id**, name)
- Room(**id**, name, *house*)
- Furniture(**id**, name, *room*)
- Shelf(**id**, name, *furniture*)
- Item(**id**, name, *shelf*)

### Fichiers utiles

- Utilitaires de la base de données : `lib/data/db`
- DAO : `lib/data/dao`

## Localisation

Fichiers de ressources dans le dossier `assets/translations/`

Pour générer le fichier `lib/generated/locale_keys.g.dart` associé (utile pour avoir un typage des champs de traduction), utiliser la commande `dart run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart`.

## Dépannage rapide

- Problème : build Android échoue avec erreur de version Gradle -> vérifier `android/gradle.properties` et la version du wrapper (`gradle/wrapper`)
- Problème : `flutter pub get` bloque -> vérifier connexion réseau, proxy, et supprimer `.pub-cache/hosted` si corrompu
- Problème : erreurs de génération de `locale_keys.g.dart` -> relancer la commande de génération ou `flutter pub run build_runner build --delete-conflicting-outputs` si applicable
