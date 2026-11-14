#!/usr/bin/env bash
set -euo pipefail

DB="olimpijske_igre"
KORISNIK="postgres"
cd "$(dirname "$0")"

psql -X -q -U "$KORISNIK" -d "$DB" -f export_csv.sql
psql -X -q -U "$KORISNIK" -d "$DB" -f export_json.sql

ls -l olimpijske_igre.csv olimpijske_igre.json
