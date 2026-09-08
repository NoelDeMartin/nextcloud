#!/usr/bin/env sh
set -eu
umask 077

# Rireki backup script
# See https://github.com/NoelDeMartin/rireki

basedir="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)"

if [ -z "${RIREKI_BACKUP_PATH:-}" ]; then
    echo "Error: RIREKI_BACKUP_PATH is not set" >&2
    exit 1
fi

tmp_dump="$RIREKI_BACKUP_PATH/dump.sql.tmp"
tmp_config="$RIREKI_BACKUP_PATH/config.php.tmp"
trap 'rm -f "$tmp_dump" "$tmp_config"' EXIT INT TERM

cd "$basedir"

echo "Backing up database..."
docker compose exec -T nextcloud-aio-database pg_dump -U nextcloud nextcloud_database > "$tmp_dump"
mv "$tmp_dump" "$RIREKI_BACKUP_PATH/dump.sql"
chmod 600 "$RIREKI_BACKUP_PATH/dump.sql"
echo "Database backed up!"

echo "Backing up config..."
docker compose exec -T nextcloud-aio-nextcloud cat /var/www/html/config/config.php > "$tmp_config"
mv "$tmp_config" "$RIREKI_BACKUP_PATH/config.php"
chmod 600 "$RIREKI_BACKUP_PATH/config.php"
echo "Config backed up!"

if [ -f "$basedir/.env" ]; then
    echo "Backing up environment..."
    cp "$basedir/.env" "$RIREKI_BACKUP_PATH/.env"
    chmod 600 "$RIREKI_BACKUP_PATH/.env"
    echo "Environment backed up!"
fi

trap - EXIT INT TERM
