# 🔗 ZenLink

Une application macOS qui nettoie automatiquement les URLs dans votre presse-papier en supprimant les paramètres de tracking indésirables.

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13.0+-blue?style=flat-square&logo=apple" alt="macOS 13.0+">
  <img src="https://img.shields.io/badge/Swift-5.0+-orange?style=flat-square&logo=swift" alt="Swift 5.0+">
  <img src="https://img.shields.io/badge/SwiftUI-3.0+-blue?style=flat-square" alt="SwiftUI 3.0+">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="MIT License">
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
git clone https://github.com/nthnbch/zenlink.git
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
https://sample.com/blog/article?utm_source=google&utm_campaign=ads&gclid=Cj0KCQiA&gad_source=1&fbclid=IwAR&normal_param=keep
```

**Après (URL nettoyée) :**
```
https://sample.com/blog/article?normal_param=keep
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

#

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

## 📄 Licence

Ce projet est sous **licence MIT**. Voir [LICENSE](LICENSE) pour les détails.


<p align="center">
  <a href="../../issues">🐛 Signaler un bug</a> •
  <a href="../../discussions">💬 Discussions</a> •
  <a href="../../releases">📦 Téléchargements</a>
</p>
