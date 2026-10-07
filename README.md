# dbmap — Database Schema Maps as Ground Truth

`dbmap` generates a database schema map (`DBMAP.md`) from a **live**
database using [tbls](https://github.com/k1LoW/tbls), auto-detects
connection strings from your project's config files (`.env`, Prisma,
Django settings, Rails database.yml, SQLAlchemy, docker-compose, and
more), and pairs the map with an index analysis (foreign keys without
indexes, filter-pattern gaps, composite candidates).

**What it is for** (and what it is not — see the measured note below):
a committed, kept-fresh **ground-truth artifact** for work without live
database access, pointed at by a repo rule. It is *not* agent-context
injection — pre-registered A/B/C evals found no task benefit from
handing maps to tool-using agents, and a 1.3–2x turn cost for invoking
the skill first.

## Install

```bash
git clone https://github.com/ariadoss/dbmap.git ~/claude-dbmap-command
```

`tbls` is required (`brew install k1LoW/tap/tbls` or `go install
github.com/k1Low/tbls/cmd/tbls@latest`); the launcher attempts the
Homebrew install for you when missing.

## Use

```bash
~/claude-dbmap-command/scripts/run.sh dbmap --list          # detect connections
~/claude-dbmap-command/scripts/run.sh dbmap --dsn 'sqlite:///path/app.db' -o DBMAP.md
```

The `/dbmap`, `/dbmap-auto-on`, `/dbmap-auto-off` slash-command files in
this repo are exported verbatim from
[superskills](https://github.com/ariadoss/superskills) (its
`scripts/export-dbmap.sh` owns exactly these three paths; everything
else here is edited via PR).

## Provenance (the improvement that matters)

Agents working without DB access correctly discount an undated,
unsourced map. When you generate or regenerate DBMAP.md, stamp the
header with the generation time, the source database, and the DSN target
— the three fields every eval run asked for. Auto-regeneration on
migrations (the auto-on toggles) keeps the stamp honest.

## Provenance of this repo

Extracted 2026-10-07 from [ariadoss/repomap](https://github.com/ariadoss/repomap)
(now deprecated), which remains the home of the tree-sitter repomap tool.
Python deps: none (stdlib + the tbls binary). MIT license, as the parent.
