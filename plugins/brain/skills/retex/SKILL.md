---
name: retex
description: Capitalise un retour d'expérience dans le second cerveau Obsidian (vault Brain) sous forme de notes atomiques dans atlas/. Utilise ce skill dès que l'utilisateur dit "retex", "retour d'expérience", "post-mortem", "leçons apprises", "capitalise ça dans mon brain", ou veut tirer les enseignements d'une merge request, d'un bug, d'un incident, d'une erreur détectée ou d'une session de travail. Use this skill whenever the user mentions retex, lessons learned, post-mortem, or wants to distill takeaways from an MR, a bug, an incident or a work session into their Obsidian second brain.
---

# Retex — capitaliser un retour d'expérience en notes atomiques

Tu distilles un retour d'expérience en **notes atomiques** dans le vault Obsidian. Vault : `/Users/maximeoger/Library/Mobile Documents/iCloud~md~obsidian/Documents/Brain`. Toutes les notes en **français**, conventions du CLAUDE.md du vault (kebab-case sans accent ni majuscule, frontmatter YAML complet, wikilinks sans chemin ni extension).

**Principe** : pas de note « événement » volumineuse, pas de dossier retex. Le retex ne laisse dans le vault que ses leçons réutilisables, une idée par note, rangées dans `atlas/<theme>/`. Maxime ne veut pas de gros volumes de texte dans le vault.

## Étape 1 — Exiger un contexte concret

Un retex part toujours d'un contexte donné : une merge request (diff, description), une erreur détectée, un incident, une session de debug, la conversation en cours, un document collé.

- Si le contexte est dans la conversation courante : l'utiliser.
- S'il manque ou reste vague (« fais un retex » sans matière) : **demander** le contexte (lien MR, description de l'erreur, ce qui s'est passé). Ne jamais inventer ni broder à partir de généralités.

## Étape 2 — Extraire les leçons

Identifie chaque enseignement du contexte : principe, piège, pattern, heuristique, cause racine.

Filtre strict — une leçon entre dans le vault seulement si :
- elle est **réutilisable hors de l'événement d'origine** (généralisable à d'autres situations) ;
- elle **apprend quelque chose** (pas une évidence, pas une règle déjà documentée ailleurs sans nuance nouvelle).

Les détails circonstanciels (noms de fichiers du jour, numéros de tickets, chronologie de l'incident) ne rentrent PAS dans le vault. Si aucune leçon ne passe le filtre, le dire et s'arrêter — ne rien écrire.

## Étape 3 — Découper en notes atomiques et proposer

Une note = une idée. Titre = l'idée formulée en principe actionnable, kebab-case (modèle existant : `corriger-la-cause-racine-pas-le-symptome.md`).

Avant de chercher où ranger, vérifie l'existant : pour chaque leçon, `grep`/`ls` dans `atlas/` pour détecter une note qui couvre déjà l'idée. Si oui, prévoir un **enrichissement** de la note existante au lieu d'un doublon.

Présente ensuite la proposition à Maxime et **attends sa validation avant d'écrire** :

```
| Note (titre kebab-case) | Thème atlas | Nouvelle / enrichit [[note]] | Idée en 1 ligne |
```

## Étape 4 — Ranger dans le bon thème atlas

Thèmes existants (vérifier avec `ls atlas/` au moment du run) : `architecture-logicielle`, `base-de-donnees`, `economie`, `entrepreneuriat`, `gains`, `ingenierie-logicielle`, `productivite`.

- Choisir le **thème existant le plus proche** par défaut.
- Proposer un **nouveau** `atlas/<theme>/` uniquement si rien ne colle vraiment, et seulement avec **confirmation explicite** de Maxime (le protocole du vault §8 interdit les dossiers hors structure). Si créé : mettre à jour le MOC `atlas.md`.

## Étape 5 — Écrire les notes

Pour chaque note validée, créer `atlas/<theme>/<titre-kebab>.md` :

```markdown
---
title: <L'idée en français lisible>
date: AAAA-MM-JJ
tags: [<theme>, retex]
status: seedling
type: note
---

# <L'idée en français lisible>

<Le principe en 2-5 phrases : quoi, pourquoi, comment l'appliquer. Reformulé, dense, sans narration de l'événement d'origine.>

**Contexte d'origine** : <1 ligne max — d'où vient la leçon (ex : « retex MR HubSpot sync, 2026-09-28 »).>

## Liens
- [[<moc-ou-note-du-theme>]]
- [[<autre-note-du-retex>]] — si plusieurs notes créées ensemble
```

Règles :
- `date` = date du jour (`date +%F`).
- Wikilinks uniquement vers des notes **existantes** (ou créées dans ce même run) — jamais de lien vers une note inexistante.
- Enrichissement d'une note existante : ajouter/affiner le contenu, ne pas dupliquer, conserver son frontmatter (mettre à jour `status` si la note mûrit).
- **Mettre à jour le MOC** du thème : certains dossiers utilisent `index.md`, d'autres la folder-note (ex : `atlas.md`) — cibler le fichier MOC réellement présent dans le dossier de destination, et **montrer le diff** de la modification du MOC avant de l'appliquer (règle du CLAUDE.md du vault).

## Étape 6 — Vérifier

1. Frontmatter complet sur chaque note créée/modifiée.
2. `bash check-dead-links.sh` depuis la racine du vault → résultat attendu : **0 lien mort**. Corriger avant de terminer sinon.
3. Terminer par un récap : notes créées (chemins), notes enrichies, MOC mis à jour.
