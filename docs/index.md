# nycdb2

This repository holds dataset definitions, dbt models, API endpoint specs, and narrative docs for NYC housing data loaded by the [opendata-etl](https://github.com/JustFixNYC/opendata-etl) framework.

## Layout

| Path | Purpose |
|------|---------|
| `repo.yml` | Repository metadata (`name`, `default_schema`, …) |
| `datasets/` | One YAML file per dataset |
| `models/` | dbt project (manifest root: `models/dbt_project.yml`) |
| `api_endpoints/` | Read-only HTTP API route definitions |
| `docs/` | Markdown aggregated into the framework MkDocs site |
| `fixtures/` | Small static files referenced by dataset YAML |

## Local validation

From a checkout of [opendata-etl](https://github.com/JustFixNYC/opendata-etl), with dev dependencies installed:

```bash
python3 scripts/validate_definitions.py --repo /absolute/path/to/nycdb2
```

## Loading this repo via `definitions.yml`

Use a pinned git ref and a `file://` URL for local work (three slashes on Unix):

```yaml
api_version: opendata-etl.definitions/v1
source_credentials: {}
definitions:
  - name: nycdb2
    url: "file:///absolute/path/to/nycdb2"
    ref: main
    schema: nyc_housing
    protected: false
```

Replace `/absolute/path/to/nycdb2` with the result of `pwd` from inside this git checkout. Use a commit SHA instead of `main` when you need a reproducible pin.
