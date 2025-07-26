#!/bin/bash

# Script pour compiler ZenLink avec les fichiers de localisation

echo "🚀 Compilation de ZenLink avec localisation..."

# Nettoyer le build précédent
echo "🧹 Nettoyage du build précédent..."
rm -rf build/

# Compiler l'application
echo "🔨 Compilation..."
xcodebuild -project ZenLink.xcodeproj -target ZenLink -configuration Release build

# Vérifier que la compilation a réussi
if [ $? -eq 0 ]; then
    echo "✅ Compilation réussie!"
    
    # Copier les fichiers de localisation dans l'app bundle
    echo "🌍 Ajout des fichiers de localisation..."
    cp -r ZenLink/en.lproj build/Release/ZenLink.app/Contents/Resources/
    cp -r ZenLink/fr.lproj build/Release/ZenLink.app/Contents/Resources/
    cp -r ZenLink/es.lproj build/Release/ZenLink.app/Contents/Resources/
    
    echo "✅ Fichiers de localisation ajoutés!"
    echo "📂 Application disponible : build/Release/ZenLink.app"
    
    # Optionnel : lancer l'app
    read -p "Voulez-vous lancer l'application? (y/n): " launch
    if [[ $launch == "y" ]]; then
        open build/Release/ZenLink.app
    fi
else
    echo "❌ Erreur de compilation!"
    exit 1
fi
