#!/usr/bin/env python3
# Test du parsing des formations multiples

formation_text = "Formation d'Ornithologie et Herpéthologie dans le milieu Aéroportuaire | Formation de contrôleurs aire de trafic"

print("=== TEST DE PARSING DES FORMATIONS ===")
print(f"Texte original: '{formation_text}'")
print(f"Longueur: {len(formation_text)}")
print(f"Contient '|': {'|' in formation_text}")

# Simulation du parsing Flutter/Dart
formations = formation_text.split('|')
formations_cleaned = [f.strip() for f in formations if f.strip() and f.strip() != 'N/A']

print(f"\n=== RÉSULTATS DU PARSING ===")
print(f"Nombre de formations trouvées: {len(formations_cleaned)}")

for i, formation in enumerate(formations_cleaned):
    print(f"Formation {i+1}: '{formation}'")
    print(f"  - Longueur: {len(formation)}")
    print(f"  - Vide: {formation == ''}")
    print(f"  - N/A: {formation == 'N/A'}")

print(f"\n=== TEST JAVASCRIPT/DART EQUIVALENT ===")
# Simulation exacte du code Dart
js_code = f"""
String formationsText = "{formation_text}";
List<String> formations = formationsText
    .split('|')
    .map((f) => f.trim())
    .where((f) => f.isNotEmpty && f != 'N/A')
    .toList();
    
print('Formations count = ${{formations.length}}');
for (int i = 0; i < formations.length; i++) {{
    print('Formation $i = "${{formations[i]}}"');
}}
"""

print("Code Dart équivalent:")
print(js_code)
