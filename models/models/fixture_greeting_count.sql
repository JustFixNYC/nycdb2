{{ config(materialized="view", tags=["fixture"]) }}

select count(*)::bigint as greeting_count
from {{ source("fixture_hello", "greetings") }}
