# Changelog

Toutes les modifications notables de ZenLink seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-07-25

### Ajouté
- ✅ **Extension majeure** : Support de **50+ paramètres** de tracking (vs 35+ précédemment)
- ✅ **UTM complet** : Ajout de `utm_id`, `utm_reader`, `utm_social`, `utm_creative`
- ✅ **Redirections** : Support complet des paramètres de redirection (`redirect*`, `rurl`, `target`, `dest*`, `next`, `to`, `continue`, `go`, `u`)
- ✅ **Referrers étendus** : Amélioration du nettoyage des referrers (`ref*`, `referrer`, `src`, `s`)
- ✅ **Tracking IDs** : Support étendu (`scid`, `icid`, `ncid`, `track`, `tracking_id`, `trk*`)

### Amélioré
- 🔧 **Documentation** : README mis à jour avec la liste complète des 50+ paramètres
- 🔧 **Organisation** : Restructuration du code des paramètres par catégories
- 🔧 **Performance** : Optimisation de la détection et suppression des paramètres

## [1.0.0] - 2025-07-25

### Ajouté
- 🎉 Version initiale de ZenLink
- ✅ Nettoyage automatique des URLs dans le presse-papier
- ✅ Support de **50+ paramètres** de tracking (UTM complet, Google Ads, Facebook, Microsoft, Amazon, redirections, referrers...)
- ✅ Interface MenuBarExtra native pour macOS 13+
- ✅ Surveillance continue du presse-papier (configurable, 500ms par défaut)
- ✅ Statistiques en temps réel (quotidien et total)
- ✅ Configuration avancée et exclusions de domaines
- ✅ Activité récente avec détails des URLs nettoyées
- ✅ Notifications optionnelles lors du nettoyage
- ✅ Performance optimisée (< 0.1% CPU, ~15-20 MB RAM)
- ✅ Traitement 100% local, aucune donnée envoyée
- ✅ Interface SwiftUI moderne et responsive
- ✅ Support des architectures Intel et Apple Silicon
- ✅ Mode menu uniquement (LSUIElement = YES)

### Paramètres de tracking supportés
- **Google Ads/Analytics** : `utm_*`, `gclid`, `gad_source`, `gbraid`, `wbraid`, `dclid`
- **Facebook** : `fbclid`, `fb_action_*`, `fb_ref`, `fb_source`
- **Amazon** : `tag`, `linkCode`, `ref`, `pf_rd_*`
- **YouTube** : `feature`, `list`, `index`
- **Twitter** : `src`, `ref_src`, `ref_url`
- **Email Marketing** : `mc_cid`, `mc_eid`, `mkt_tok`
- **Analytics divers** : `_ga`, `_gl`, `_hsenc`, `_hsmi`
- **Autres** : `yclid`, `msclkid`, `epik`, `igshid`, `ssid`, et plus...

### Technique
- Swift 5.0+ avec SwiftUI
- Minimum macOS 13.0 (Ventura)
- URLComponents pour parsing précis des URLs
- NSPasteboard pour surveillance système
- UserDefaults pour persistance des préférences
- Timer configurable pour surveillance périodique
- Architecture MVVM avec ObservableObject

---

## [Unreleased]

### À venir
- [ ] Résolution automatique des redirections
- [ ] Support de nouveaux paramètres de tracking
- [ ] Raccourcis clavier personnalisables
- [ ] Interface de gestion des règles avancées
- [ ] Export/import des préférences
- [ ] Mode sombre personnalisé
- [ ] Tests unitaires et d'intégration
