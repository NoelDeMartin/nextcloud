#!/usr/bin/env sh
set -eu

# Rireki backup script
# See https://github.com/NoelDeMartin/rireki

basedir="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)"

if [ -z "${RIREKI_BACKUP_PATH:-}" ]; then
    echo "Error: RIREKI_BACKUP_PATH is not set" >&2
    exit 1
fi

tmp_dump="$RIREKI_BACKUP_PATH/dump.sql.tmp"
trap 'rm -f "$tmp_dump"' EXIT INT TERM

echo "Backing up database..."
cd "$basedir"
docker compose exec -T nextcloud-aio-database pg_dump -U nextcloud nextcloud_database > "$tmp_dump"
mv "$tmp_dump" "$RIREKI_BACKUP_PATH/dump.sql"
trap - EXIT INT TERM

echo "Database backed up!"
