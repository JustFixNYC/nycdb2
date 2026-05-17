# Step 15 representative datasets

Five dataset patterns exercise the full opendata-etl extract→staging→load path. Sources and CI tiers follow the [Step 15 planning doc](https://github.com/JustFixNYC/opendata-etl/blob/main/docs/column-names.md) in the framework repo and `_planning/opendata-etl_step_15_nycdb_candidates.plan.md`.

## Datasets

| Dataset | Pattern | Source | CI tier |
|---------|---------|--------|---------|
| `hpd_violations` | large_csv | [NYC Open Data](https://data.cityofnewyork.us/Housing-Development/Housing-Maintenance-Code-Violations/wvxf-dwi5) CSV download | A (fixture), C (full load) |
| `rentstab_v2` | public_s3_csv | `s3://justfix-data/rentstab_counts_from_doffer_2024.csv` | B E2E |
| `nycc` | shapefile | [DCP nycc_26a.zip](https://s-media.nyc.gov/agencies/dcp/assets/files/zip/data-tools/bytes/city-council/nycc_26a.zip) | B E2E |
| `hpd_vacateorders` | protected_s3 | `s3://opendata-etl-testing/hpd_vacateorders.csv` | Local only (IAM) |
| `hpd_registrations` | multi_table_bundle | NYC Open Data registrations + contacts | A (fixtures), C (full) |

## Validation (Tier A)

From an `opendata-etl` checkout with dev dependencies:

```bash
python3 scripts/validate_definitions.py --repo "$(pwd)"   # when cwd is nycdb2

python3 scripts/validate_definitions.py --repo /path/to/nycdb2 \
  --sample-csv /path/to/nycdb2/fixtures/hpd_violations_sample.csv \
  --dataset hpd_violations --table hpd_violations

python3 scripts/validate_definitions.py --repo /path/to/nycdb2 \
  --sample-csv /path/to/nycdb2/fixtures/nycc_sample.csv \
  --dataset nycc --table nycc

python3 scripts/validate_definitions.py --repo /path/to/nycdb2 \
  --sample-csv /path/to/nycdb2/fixtures/hpd_registrations_sample.csv \
  --dataset hpd_registrations --table hpd_registrations

python3 scripts/validate_definitions.py --repo /path/to/nycdb2 \
  --sample-csv /path/to/nycdb2/fixtures/hpd_contacts_sample.csv \
  --dataset hpd_registrations --table hpd_contacts
```

## Local materialize (Tier B / C)

Use `examples/definitions.local.yml` in `opendata-etl` with a `file://` URL to this repo (see framework `docs/local-development.md`). Ensure Postgres/PostGIS is running and `DATABASE_URL` is set. GDAL `ogr2ogr` is required for `nycc`.

```bash
cd /path/to/opendata-etl
export DATABASE_URL=postgresql://opendata:opendata@127.0.0.1:5432/opendata
export OPENDATA_DEFINITIONS_MANIFEST_PATH=examples/definitions.local.yml
export OPENDATA_DAGSTER_DEFINITION_LOAD=clone
export OPENDATA_DAGSTER_MATERIALIZE=full

# Tier B — public S3 + shapefile
dagster asset materialize -m pipeline.dagster_defs \
  --select 'nycdb2/nyc_housing/rentstab_v2/rentstab_v2'

dagster asset materialize -m pipeline.dagster_defs \
  --select 'nycdb2/nyc_housing/nycc/nycc'

# Tier C — large CSV (long download; not for PR CI)
dagster asset materialize -m pipeline.dagster_defs \
  --select 'nycdb2/nyc_housing/hpd_violations/hpd_violations'

# Protected S3 — set AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY in .env first
dagster asset materialize -m pipeline.dagster_defs \
  --select 'nycdb2/nyc_housing/hpd_vacateorders/hpd_vacateorders'
```

Framework integration tests (optional): `OPENDATA_STEP15_E2E=1 OPENDATA_LOADER_TEST_DATABASE_URL=... pytest tests/test_step15_e2e.py -q`

## Fixtures vs live URLs

- `fixtures/hpd_violations_sample.csv` — **50 rows** from the SODA API (`?$limit=50`); keep under ~100 KB for git. Do not commit the full NYC Open Data CSV (~4 GB). `column_aliases` map API `boro`/`zip` to `borough`/`postcode`.
- `fixtures/hpd_registrations_sample.csv` and `fixtures/hpd_contacts_sample.csv` — small FK-safe subsets for schema checks.
- `fixtures/nycc_sample.csv` — synthetic WKT row for header/geometry contract validation (not for geometry accuracy).
