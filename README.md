# nycdb2

First definition repository for the `opendata-etl` project. Contains NYC housing-related datasets, dbt models, API endpoints, and narrative docs.

This directory is reserved for the `nycdb2` content that will be built per the master plan, primarily in Step 14 onward. Nothing is implemented yet.

## What this repo is

- A pure declarative definition repository: YAML dataset definitions, dbt models, API endpoint YAMLs, and markdown docs.
- Loaded at deployment time by the `opendata-etl` framework via a deployment's `definitions.yml`.
- License is at the discretion of the repo's owners (the framework's AGPLv3 does not apply here).

## What this repo is NOT

- It does not contain framework Python code. That lives in `../opendata-etl`.
- It does not contain deployment configuration. That lives in `../opendata-etl-deployment`.

## Source-of-truth documents

These live in the shared `_planning/` folder of the multi-repo workspace, not inside this repo:

- Master plan (agent-led implementation): `../_planning/opendata-etl_master_plan.plan.md`
- Architecture plan (decisions and rationale): `../_planning/etl_pipeline_tech_stack.plan.md`

## Status

Empty placeholder. The `nycdb2` scaffold step (Step 14 of the master plan) has not run yet. The framework's Step 1 scaffolding should be completed first.
