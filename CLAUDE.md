# ai-workflow-tools

Plugin marketplace Claude Code (voir `README.md`).

## Règles Git

- **Ne jamais push sur `master`** (ni `main`), ni directement ni via `HEAD:master`, ni en force.
- Toujours travailler sur une branche dédiée : `git checkout -b <type>/<sujet>` depuis `master` à jour (ex. `feat/retex-tags`, `fix/bootstrap-path`).
- Commit sur la branche, `git push -u origin <branche>`, puis **ouvrir une pull request** vers `master`.
- Ne pas merger la PR soi-même : c'est à Maxime de relire et merger.
- Si on est déjà sur `master` avec des changements non commités, créer la branche avant de commiter (`git checkout -b ...` conserve les changements).

Ces règles sont aussi appliquées par un hook (`.claude/hooks/block-push-to-master.sh`) qui refuse tout `git push` visant `master`/`main`.
