import Foundation

class URLCleaner {
    
    // Paramètres de tracking courants à supprimer
    private let trackingParameters = [
        // UTM Parameters (Google Analytics)
        "utm_source", "utm_medium", "utm_campaign", "utm_term", "utm_content",
        "utm_id", "utm_reader", "utm_social", "utm_creative",
        
        // Google Ads & Analytics
        "gclid", "gclsrc", "gbraid", "wbraid", "gad_source", "gad", "dclid",
        "_ga", "_gl", "_hsenc", "_hsmi",
        
        // Facebook
        "fbclid", "fb_action_ids", "fb_action_types", "fb_ref", "fb_source",
        
        // Microsoft/Bing
        "msclkid",
        
        // Email Marketing
        "mc_cid", "mc_eid", "mkt_tok",
        
        // Various tracking IDs
        "scid", "icid", "ncid", "yclid", "s_cid", "elqTrackId", "elqTrack",
        "igshid", "epik", "pp", "ssid",
        
        // Redirects & Navigation
        "redirect", "redirect_url", "rurl", "url", "target", "dest", "destination",
        "next", "to", "continue", "go", "u",
        
        // Referrer tracking
        "ref", "referrer", "ref_src", "ref_url", "src", "s",
        
        // Tracking & Campaign
        "track", "tracking_id", "trk", "trkCampaign", "trkEmail",
        "source", "medium", "campaign", "content", "term",
        
        // Amazon
        "tag", "linkCode", "ref_", "pf_rd_p", "pf_rd_r", "pf_rd_s", "pf_rd_t", "pf_rd_i", "pf_rd_m",
        
        // YouTube
        "feature", "list", "index",
        
        // Other platforms
        "at_medium", "at_campaign", "at_source",
        "vero_conv", "vero_id",
        "CNDID", "amp;CNDID",
        "zanpid", "ranMID", "ranEAID", "ranSiteID"
    ]
    
    // Domaines de redirection à déplier
    private let redirectDomains = [
        "bit.ly", "tinyurl.com", "t.co", "short.link", "ow.ly",
        "buff.ly", "soo.gd", "s2r.co", "clicky.me", "lnkd.in",
        "youtu.be", "goo.gl", "amzn.to", "trib.al"
    ]
    
    func cleanURL(_ urlString: String) -> String {
        guard let url = URL(string: urlString) else {
            return urlString
        }
        
        var cleanedURL = url
        
        // 1. Supprimer les paramètres de tracking
        if AppSettings.shared.removeTrackingParams {
            cleanedURL = removeTrackingParameters(from: cleanedURL)
        }
        
        // 2. Normaliser l'URL
        if AppSettings.shared.normalizeUrls {
            cleanedURL = normalizeURL(cleanedURL)
        }
        
        // 3. Gérer les redirections (optionnel, plus complexe)
        if AppSettings.shared.removeRedirects {
            cleanedURL = handleRedirects(cleanedURL)
        }
        
        return cleanedURL.absoluteString
    }
    
    private func removeTrackingParameters(from url: URL) -> URL {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }
        
        // Filtrer les paramètres de requête
        if let queryItems = components.queryItems {
            let filteredItems = queryItems.filter { item in
                !trackingParameters.contains(item.name.lowercased())
            }
            
            components.queryItems = filteredItems.isEmpty ? nil : filteredItems
        }
        
        // Nettoyer le fragment (hash) s'il contient des paramètres de tracking
        if let fragment = components.fragment, fragment.contains("utm_") || fragment.contains("fbclid") {
            components.fragment = nil
        }
        
        return components.url ?? url
    }
    
    private func normalizeURL(_ url: URL) -> URL {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }
        
        // Normaliser le schéma en minuscules
        components.scheme = components.scheme?.lowercased()
        
        // Normaliser l'hôte en minuscules
        components.host = components.host?.lowercased()
        
        // Supprimer le port par défaut
        if let port = components.port {
            let scheme = components.scheme?.lowercased()
            if (scheme == "http" && port == 80) || (scheme == "https" && port == 443) {
                components.port = nil
            }
        }
        
        // Normaliser le chemin
        if let path = components.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
            components.path = path
        }
        
        // Supprimer le slash final superflu
        if components.path.hasSuffix("/") && components.path.count > 1 {
            components.path = String(components.path.dropLast())
        }
        
        // Trier les paramètres de requête pour une URL canonique
        if let queryItems = components.queryItems {
            components.queryItems = queryItems.sorted { $0.name < $1.name }
        }
        
        return components.url ?? url
    }
    
    private func handleRedirects(_ url: URL) -> URL {
        // Pour les redirections, nous nous contentons de détecter les domaines connus
        // Une implémentation complète nécessiterait des requêtes réseau
        guard let host = url.host?.lowercased() else {
            return url
        }
        
        // Gestion spéciale pour certains raccourcisseurs
        if host == "youtu.be" {
            return convertYouTuBeURL(url)
        }
        
        // Pour les autres domaines de redirection, on garde l'URL telle quelle
        // car résoudre la redirection nécessiterait une requête réseau
        return url
    }
    
    private func convertYouTuBeURL(_ url: URL) -> URL {
        // Convertir youtu.be/ID en youtube.com/watch?v=ID
        let pathComponents = url.pathComponents
        guard pathComponents.count >= 2,
              let videoId = pathComponents.last else {
            return url
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.youtube.com"
        components.path = "/watch"
        components.queryItems = [URLQueryItem(name: "v", value: videoId)]
        
        // Préserver les paramètres de temps si présents
        if let query = url.query, let tParam = extractTimeParameter(from: query) {
            components.queryItems?.append(URLQueryItem(name: "t", value: tParam))
        }
        
        return components.url ?? url
    }
    
    private func extractTimeParameter(from query: String) -> String? {
        let pairs = query.components(separatedBy: "&")
        for pair in pairs {
            let keyValue = pair.components(separatedBy: "=")
            if keyValue.count == 2 && keyValue[0] == "t" {
                return keyValue[1]
            }
        }
        return nil
    }
}
