# ai-workflow-tools

Ma collection d'outils pour mon workflow IA, distribuée comme **plugin marketplace Claude Code**.

## Plugins

| Plugin | Skills | Description |
|---|---|---|
| `brain` | `retex` | Skills qui alimentent le second cerveau Obsidian (vault Brain) |
| `dev-tools` | `new-workspace` | Outillage de workflow dev |

## Installation

```bash
claude plugin marketplace add maximeoger/ai-workflow-tools
claude plugin install brain@ai-workflow-tools
claude plugin install dev-tools@ai-workflow-tools   # optionnel
```

Installé au scope user par défaut → disponible dans tous les projets. Invocation : `/brain:retex`, `/dev-tools:new-workspace`, ou déclenchement automatique par la description du skill.

## Mise à jour

```bash
claude plugin update brain@ai-workflow-tools
```

Ou activer l'auto-update de la marketplace dans `/plugin` → Marketplaces.

## Ajouter un skill

1. Créer `plugins/<plugin>/skills/<nom-du-skill>/SKILL.md` (frontmatter `name` + `description`).
2. Pour un nouveau plugin : créer `plugins/<plugin>/.claude-plugin/plugin.json` et l'ajouter au tableau `plugins` de `.claude-plugin/marketplace.json`.
3. Valider : `claude plugin validate .`
4. Commit + push, puis `claude plugin update <plugin>@ai-workflow-tools`.
