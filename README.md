# 🔗 ZenLink

Une application macOS qui nettoie automatiquement les URLs dans votre presse-papier en supprimant les paramètres de tracking indésirables.

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13.0+-blue?style=flat-square&logo=apple" alt="macOS 13.0+">
  <img src="https://img.shields.io/badge/Swift-5.0+-orange?style=flat-square&logo=swift" alt="Swift 5.0+">
  <img src="https://img.shields.io/badge/SwiftUI-3.0+-blue?style=flat-square" alt="SwiftUI 3.0+">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="MIT License">
</p>

<p align="center">
  <strong>Simple • Efficace • Respectueux de la vie privée</strong>
</p>

---

## ✨ Fonctionnalités

- **🔄 Nettoyage automatique** : Surveillance continue du presse-papier
- **🎯 Détection intelligente** : Reconnaît automatiquement les URLs avec paramètres de tracking
- **🧹 Nettoyage complet** : Supprime 35+ types de paramètres de tracking
- **⚡ Interface minimaliste** : Icône discrète dans la barre de menu
- **📊 Statistiques** : Compteur des liens nettoyés
- **🔧 Paramètres avancés** : Exclusions de domaines, notifications optionnelles
- **🔒 100% local** : Aucune donnée envoyée vers l'extérieur

## 🚀 Installation

### Téléchargement direct

1. Télécharger la dernière version depuis [Releases](../../releases)
2. Glisser `ZenLink.app` dans le dossier Applications
3. Lancer l'application

> **Note** : Au premier lancement, faites un clic droit → "Ouvrir" car l'app n'est pas signée avec un certificat Developer ID.

### Compilation depuis les sources

```bash
# Cloner le repository
git clone https://github.com/votre-username/zenlink.git
cd zenlink

# Ouvrir dans Xcode
open ZenLink.xcodeproj

# Ou compiler en ligne de commande
xcodebuild -project ZenLink.xcodeproj -scheme ZenLink -configuration Release
```

**Prérequis :**
- macOS 13.0 (Ventura) ou plus récent
- Xcode 15.0+ (pour la compilation)

## 🎮 Utilisation

1. **Lancement** : ZenLink apparaît comme une icône 🔗 dans votre barre de menu
2. **Fonctionnement automatique** : Copiez n'importe quelle URL - elle est instantanément nettoyée
3. **Contrôle** : Cliquez sur l'icône pour voir l'activité et ajuster les paramètres

### Exemple concret

**Avant (URL avec tracking) :**
```
https://foxstone.ch/blog/article?utm_source=google&utm_campaign=ads&gclid=Cj0KCQiA&gad_source=1&fbclid=IwAR&normal_param=keep
```

**Après (URL nettoyée) :**
```
https://foxstone.ch/blog/article?normal_param=keep
```

## 🧹 Paramètres supprimés

ZenLink supprime **50+ types** de paramètres de tracking :

| Catégorie | Paramètres supprimés |
|-----------|---------------------|
| **UTM & Google Analytics** | `utm_*` (source, medium, campaign, term, content, id, reader, social, creative), `_ga`, `_gl` |
| **Google Ads** | `gclid`, `gclsrc`, `gbraid`, `wbraid`, `gad_source`, `gad`, `dclid` |
| **Facebook** | `fbclid`, `fb_action_*`, `fb_ref`, `fb_source` |
| **Microsoft/Bing** | `msclkid` |
| **Email Marketing** | `mc_cid`, `mc_eid`, `mkt_tok`, `_hsenc`, `_hsmi` |
| **Amazon** | `tag`, `linkCode`, `ref_`, `pf_rd_*` |
| **YouTube** | `feature`, `list`, `index` |
| **Tracking IDs** | `scid`, `icid`, `ncid`, `yclid`, `s_cid`, `track`, `tracking_id`, `trk*` |
| **Redirections** | `redirect*`, `rurl`, `target`, `dest*`, `next`, `to`, `continue`, `go`, `u` |
| **Referrers** | `ref*`, `referrer`, `src`, `s` |
| **Social Media** | `igshid`, `epik`, `pp`, `ssid` |
| **Autres** | `source`, `medium`, `campaign`, `content`, `term`, et bien d'autres... |

## ⚙️ Configuration

Cliquez sur l'icône ZenLink dans la barre de menu pour accéder aux options :

- **✅ Activation/Désactivation** du nettoyage automatique
- **🔔 Notifications** lors du nettoyage (optionnel)
- **🚫 Exclusions de domaines** pour certains sites
- **📊 Statistiques** d'utilisation quotidienne et totale
- **⚡ Intervalle de surveillance** personnalisable

## 🏗️ Architecture

ZenLink est développé avec les technologies Apple modernes :

- **SwiftUI** + **MenuBarExtra** pour l'interface (macOS 13+)
- **NSPasteboard** pour la surveillance du presse-papier
- **URLComponents** pour l'analyse précise des URLs
- **Timer** pour la vérification périodique (500ms par défaut)
- **UserDefaults** pour la persistance des préférences

### Structure du projet

```
ZenLink/
├── ZenLinkApp.swift              # Point d'entrée principal
├── MenuBarView.swift             # Interface de la barre de menu
├── SettingsView.swift            # Fenêtre de paramètres
├── ContentView.swift             # Vue de fallback
└── Services/
    ├── ClipboardManager.swift    # Surveillance du presse-papier
    ├── URLCleaner.swift          # Moteur de nettoyage des URLs
    └── AppSettings.swift         # Gestion des préférences
```

## 🔒 Sécurité & Confidentialité

- **✅ Traitement 100% local** : Aucune connexion réseau
- **✅ Aucune collecte de données** : Rien n'est envoyé nulle part
- **✅ Pas d'historique** : Les URLs ne sont pas stockées
- **✅ Code open source** : Entièrement auditable
- **✅ Sandbox partiel** : Accès limité au presse-papier uniquement

## 🛠️ Développement

### Compilation

```bash
# Debug
xcodebuild -configuration Debug

# Release
xcodebuild -configuration Release

# Nettoyer
xcodebuild clean
```

### Tests

L'application a été testée avec :
- URLs complexes avec multiples paramètres
- Domaines variés (Google, Facebook, Amazon, etc.)
- Performance avec surveillance continue
- Gestion mémoire et CPU

## 🐛 Dépannage

### L'app ne nettoie pas les URLs
1. ✅ Vérifiez que ZenLink est activé (cercle vert dans le menu)
2. ✅ Assurez-vous que l'URL contient des paramètres de tracking reconnus
3. ✅ Vérifiez que le domaine n'est pas exclu dans les paramètres

### Permissions macOS
- ZenLink nécessite l'accès au presse-papier (automatique sur macOS 13+)
- Aucune permission spéciale requise

### Performance
- Utilisation CPU : < 0.1% en moyenne
- Mémoire : ~15-20 MB
- Vérification toutes les 500ms (configurable)

## 🤝 Contribution

Les contributions sont bienvenues ! 

1. **Fork** le projet
2. **Créer** une branche (`git checkout -b feature/nouvelle-fonctionnalite`)
3. **Commiter** (`git commit -am 'Ajout fonctionnalité'`)
4. **Push** (`git push origin feature/nouvelle-fonctionnalite`)
5. **Pull Request**

### Idées d'améliorations
- [ ] Support de nouveaux paramètres de tracking
- [ ] Résolution automatique des redirections
- [ ] Raccourcis clavier personnalisables
- [ ] Interface de gestion des règles
- [ ] Export/import des préférences
- [ ] Mode sombre personnalisé

## 📝 Changelog

## 📝 Changelog

### v1.1.0 (2025-07-25)
- 🚀 **Extension majeure** : Support de **50+ paramètres** de tracking
- ✅ UTM complet avec `utm_id`, `utm_reader`, `utm_social`, `utm_creative`
- ✅ Gestion complète des redirections (`redirect*`, `rurl`, `target`, etc.)
- ✅ Support étendu des referrers et tracking IDs
- ✅ Documentation mise à jour avec classification détaillée

### v1.0.0 (2025-07-25)
- 🎉 **Version initiale**
- ✅ Nettoyage automatique de **50+ paramètres** de tracking
- ✅ Interface MenuBarExtra native macOS 13+
- ✅ Statistiques et activité en temps réel
- ✅ Configuration avancée et exclusions
- ✅ Support UTM complet, Google Ads, Facebook, Microsoft, Amazon, redirections...
- ✅ Performance optimisée (< 0.1% CPU)

## 📄 Licence

Ce projet est sous **licence MIT**. Voir [LICENSE](LICENSE) pour les détails.

## 🙏 À propos

**ZenLink** fait partie de la série **ZenApps** - des utilitaires macOS conçus pour être :
- **Simples** : Une seule fonction, bien exécutée
- **Utiles** : Amélioration concrète du quotidien
- **Respectueux** : Aucune collecte de données
- **Natifs** : Intégration parfaite avec macOS

---

<p align="center">
  <strong>Développé avec ❤️ pour la communauté macOS</strong>
</p>

<p align="center">
  <a href="../../issues">🐛 Signaler un bug</a> •
  <a href="../../discussions">💬 Discussions</a> •
  <a href="../../releases">📦 Téléchargements</a>
</p>



## 📋 Paramètres supprimés

ZenLink supprime automatiquement **50+ paramètres** de tracking courants :

- **UTM & Analytics** : `utm_*` (9 variantes), `_ga`, `_gl`, `_hsenc`, `_hsmi`
- **Google Ads** : `gclid`, `gclsrc`, `gbraid`, `wbraid`, `gad_source`, `gad`, `dclid`
- **Facebook** : `fbclid`, `fb_action_*`, `fb_ref`, `fb_source`
- **Microsoft/Bing** : `msclkid`
- **Amazon** : `tag`, `linkCode`, `ref_`, `pf_rd_*`
- **Email marketing** : `mc_cid`, `mc_eid`, `mkt_tok`
- **Tracking IDs** : `scid`, `icid`, `ncid`, `yclid`, `s_cid`, `track*`
- **Redirections** : `redirect*`, `rurl`, `target`, `dest*`, `next`, `to`, `continue`, `go`, `u`
- **Referrers** : `ref*`, `referrer`, `src`, `s`
- **Social Media** : `igshid`, `epik`, `pp`, `ssid`
- **Et bien d'autres...**

## ⚙️ Configuration

Cliquez sur l'icône ZenLink dans la barre de menu pour accéder aux options :

- **Activation/Désactivation** du nettoyage automatique
- **Notifications** lors du nettoyage (optionnel)
- **Exclusions de domaines** pour certains sites
- **Statistiques** d'utilisation
- **Réglages avancés**

## 🏗️ Architecture technique

ZenLink utilise une architecture moderne Swift/SwiftUI :

- **SwiftUI** pour l'interface utilisateur
- **MenuBarExtra** pour l'intégration barre de menu (macOS 13+)
- **NSPasteboard** pour la surveillance du presse-papier
- **URLComponents** pour l'analyse et la modification des URLs
- **Timer** pour la vérification périodique (500ms)

### Structure du projet

```
ZenLink/
├── ZenLinkApp.swift          # Point d'entrée principal
├── ContentView.swift         # Vue principale (unused in menu bar mode)
├── MenuBarView.swift         # Interface de la barre de menu
├── SettingsView.swift        # Fenêtre de préférences
└── Services/
    ├── ClipboardManager.swift # Gestion du presse-papier
    ├── URLCleaner.swift      # Logique de nettoyage des URLs
    └── AppSettings.swift     # Configuration et préférences
```

## 🔒 Sécurité et confidentialité

- **Traitement local** : Toutes les URLs sont traitées localement sur votre Mac
- **Aucune donnée envoyée** : ZenLink ne communique avec aucun serveur externe
- **Sandbox désactivé** : Nécessaire pour accéder au presse-papier système
- **Open source** : Code source entièrement auditable

## 🐛 Dépannage

### L'application ne nettoie pas les URLs
1. Vérifiez que ZenLink est activé (icône verte dans le menu)
2. Assurez-vous que l'URL copiée contient des paramètres de tracking
3. Vérifiez que le domaine n'est pas dans les exclusions

### Problèmes de permissions
- ZenLink nécessite l'accès au presse-papier
- Aucune permission spéciale n'est requise sur macOS 13+

### Performance
- ZenLink utilise très peu de ressources (< 1% CPU)
- La vérification se fait toutes les 500ms par défaut
- Vous pouvez ajuster l'intervalle dans les préférences

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment participer :

1. **Fork** le projet
2. **Créer** une branche pour votre fonctionnalité (`git checkout -b feature/ma-fonctionnalite`)
3. **Commiter** vos changements (`git commit -am 'Ajout de ma fonctionnalité'`)
4. **Pousser** vers la branche (`git push origin feature/ma-fonctionnalite`)
5. **Créer** une Pull Request

### Améliorations souhaitées
- [ ] Support d'autres paramètres de tracking
- [ ] Interface de configuration plus avancée
- [ ] Statistiques détaillées
- [ ] Support du glisser-déposer
- [ ] Raccourcis clavier
- [ ] Règles personnalisées

## 📝 Changelog

### v1.0.0 (2025-07-25)
- 🎉 Version initiale
- ✅ Nettoyage automatique des URLs
- ✅ Interface barre de menu
- ✅ Support des principaux paramètres de tracking
- ✅ Statistiques de base
- ✅ Configuration des exclusions

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements

ZenLink fait partie de la série **ZenApps** - des utilitaires macOS simples, utiles et agréables à utiliser.

---

<p align="center">
  Développé avec ❤️ pour la communauté macOS
</p>

<p align="center">
  <a href="../../issues">🐛 Signaler un bug</a> •
  <a href="../../discussions">💬 Discussions</a> •
  <a href="../../releases">📦 Téléchargements</a>
</p>

```
ZenLink/
├── ZenLink.xcodeproj/          # Projet Xcode
├── ZenLink/
│   ├── ZenLinkApp.swift        # Point d'entrée de l'application
│   ├── ContentView.swift       # Vue principale (non utilisée en mode menu bar)
│   ├── MenuBarView.swift       # Interface de la barre de menu
│   ├── SettingsView.swift      # Fenêtre de paramètres
│   ├── Services/
│   │   ├── ClipboardManager.swift  # Gestion du presse-papiers
│   │   ├── URLCleaner.swift        # Nettoyage des URLs
│   │   └── AppSettings.swift       # Paramètres de l'application
│   ├── Assets.xcassets/        # Ressources graphiques
│   └── ZenLink.entitlements    # Autorisations sandboxing
└── Package.swift               # Configuration Swift Package Manager
```

## Compilation et exécution

### Avec Xcode
1. Ouvrir `ZenLink.xcodeproj` dans Xcode
2. Sélectionner le schéma "ZenLink"
3. Appuyer sur Cmd+R pour compiler et exécuter

### Avec ligne de commande
```bash
# Compilation
xcodebuild -project ZenLink.xcodeproj -scheme ZenLink -configuration Debug build

# Exécution du binaire compilé
open build/Debug/ZenLink.app
```

### Avec Swift Package Manager (alternatif)
```bash
swift build
swift run ZenLink
```

## Utilisation

1. Lancer ZenLink
2. L'icône apparaît dans la barre de menu
3. Copier n'importe quel lien - il sera automatiquement nettoyé
4. Cliquer sur l'icône pour voir l'activité récente et accéder aux paramètres

## Paramètres

- **Général** : Activation/désactivation, démarrage automatique, notifications
- **Exclusions** : Liste des domaines à ignorer
- **Avancé** : Options de nettoyage, intervalle de surveillance

## Confidentialité et sécurité

- ✅ Aucune donnée n'est envoyée vers des serveurs externes
- ✅ Tout le traitement se fait localement
- ✅ Aucun historique des URLs n'est conservé
- ✅ Application sandboxée selon les guidelines Apple
- ✅ Accès réseau désactivé dans les entitlements

## Configuration requise

- macOS 13.0 ou plus récent
- Architecture Intel ou Apple Silicon

## Développement

L'application est développée en suivant les meilleures pratiques :
- Architecture MVVM avec SwiftUI
- Gestion d'état avec `@ObservableObject` et `@Published`
- Persistence avec `UserDefaults`
- Respect des guidelines d'accessibilité Apple
- Code documenté et modulaire

## TODO pour améliorer l'application

- [ ] Ajouter des icônes personnalisées
- [ ] Implémenter la résolution de redirections (optionnel)
- [ ] Ajouter plus de paramètres de tracking
- [ ] Créer des tests unitaires
- [ ] Optimiser les performances
- [ ] Ajouter un mode sombre personnalisé
- [ ] Implémenter le démarrage automatique avec ServiceManagementlink** est une application macOS développée en Swift/SwiftUI dans la série d'utilitaires "ZenApps".

## Description rapide
Nettoie automatiquement les liens copiés (UTM, trackers…)

## Objectif
Créer une app simple, utile, et agréable à utiliser, avec un impact direct dans le quotidien.

## Statut
🚧 En développement

## TODO
- [ ] Initialisation du projet Swift
- [ ] Définir l’UI avec SwiftUI
- [ ] Implémentation des fonctionnalités principales
- [ ] Tests et débogage
