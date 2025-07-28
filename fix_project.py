#!/usr/bin/env python3

import re
import sys

# Lire le contenu du project.pbxproj
with open("ZenLink.xcodeproj/project.pbxproj", "r") as f:
    content = f.read()

# Supprimer les références à LocalizationManager et ThemeManager
content = re.sub(r'\s*1A000018294F1A7000000001 /\* ThemeManager\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 1A000018294F1A7000000001 /\* ThemeManager\.swift \*/; \};.*\n', '', content)
content = re.sub(r'\s*1A000020294F1A7500000001 /\* LocalizationManager\.swift in Sources \*/ = \{isa = PBXBuildFile; fileRef = 1A00001F294F1A7500000001 /\* LocalizationManager\.swift \*/; \};.*\n', '', content)
content = re.sub(r'\s*1A000018294F1A7000000001 /\* ThemeManager\.swift \*/ = \{isa = PBXFileReference; lastKnownFileType = sourcecode\.swift; path = ThemeManager\.swift; sourceTree = "<group>"; \};.*\n', '', content)
content = re.sub(r'\s*1A00001F294F1A7500000001 /\* LocalizationManager\.swift \*/ = \{isa = PBXFileReference; lastKnownFileType = sourcecode\.swift; path = LocalizationManager\.swift; sourceTree = "<group>"; \};.*\n', '', content)
content = re.sub(r'\s*1A000018294F1A7000000001 /\* ThemeManager\.swift \*/,.*\n', '', content)
content = re.sub(r'\s*1A00001F294F1A7500000001 /\* LocalizationManager\.swift \*/,.*\n', '', content)
content = re.sub(r'\s*1A000020294F1A7500000001 /\* LocalizationManager\.swift in Sources \*/,.*\n', '', content)
content = re.sub(r'\s*1A000019294F1A7000000001 /\* ThemeManager\.swift in Sources \*/,.*\n', '', content)

# Générer de nouveaux UUID
import uuid
theme_file_ref = str(uuid.uuid4()).replace('-', '').upper()[:24]
theme_build_file = str(uuid.uuid4()).replace('-', '').upper()[:24]
local_file_ref = str(uuid.uuid4()).replace('-', '').upper()[:24]
local_build_file = str(uuid.uuid4()).replace('-', '').upper()[:24]

# Ajouter les nouvelles références après AppSettings
build_files_section = content.find("/* Begin PBXBuildFile section */")
app_settings_build = content.find("1A000018294F1A6800000001 /* AppSettings.swift in Sources */", build_files_section)
if app_settings_build != -1:
    insert_pos = content.find("\n", app_settings_build) + 1
    new_build_files = f"\t\t{local_build_file} /* LocalizationManager.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {local_file_ref} /* LocalizationManager.swift */; }};\n"
    new_build_files += f"\t\t{theme_build_file} /* ThemeManager.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {theme_file_ref} /* ThemeManager.swift */; }};\n"
    content = content[:insert_pos] + new_build_files + content[insert_pos:]

# Ajouter les nouvelles file references après AppSettings
file_ref_section = content.find("/* Begin PBXFileReference section */")
app_settings_ref = content.find("1A000017294F1A6800000001 /* AppSettings.swift */", file_ref_section)
if app_settings_ref != -1:
    insert_pos = content.find("\n", app_settings_ref) + 1
    new_file_refs = f"\t\t{local_file_ref} /* LocalizationManager.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = LocalizationManager.swift; sourceTree = \"<group>\"; }};\n"
    new_file_refs += f"\t\t{theme_file_ref} /* ThemeManager.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ThemeManager.swift; sourceTree = \"<group>\"; }};\n"
    content = content[:insert_pos] + new_file_refs + content[insert_pos:]

# Ajouter dans le groupe Services
services_group = content.find("1A000017294F1A6800000001 /* AppSettings.swift */,")
if services_group != -1:
    insert_pos = content.find("\n", services_group) + 1
    new_group_refs = f"\t\t\t\t{local_file_ref} /* LocalizationManager.swift */,\n"
    new_group_refs += f"\t\t\t\t{theme_file_ref} /* ThemeManager.swift */,\n"
    content = content[:insert_pos] + new_group_refs + content[insert_pos:]

# Ajouter dans Sources build phase
sources_phase = content.find("1A000018294F1A6800000001 /* AppSettings.swift in Sources */,")
if sources_phase != -1:
    insert_pos = content.find("\n", sources_phase) + 1
    new_sources = f"\t\t\t\t{local_build_file} /* LocalizationManager.swift in Sources */,\n"
    new_sources += f"\t\t\t\t{theme_build_file} /* ThemeManager.swift in Sources */,\n"
    content = content[:insert_pos] + new_sources + content[insert_pos:]

# Écrire le nouveau contenu
with open("ZenLink.xcodeproj/project.pbxproj", "w") as f:
    f.write(content)

print("Project fixed with new UUIDs:")
print(f"LocalizationManager file ref: {local_file_ref}")
print(f"LocalizationManager build file: {local_build_file}")
print(f"ThemeManager file ref: {theme_file_ref}")
print(f"ThemeManager build file: {theme_build_file}")
