#!/bin/bash

FECHA=$(date +%Y%m%d_%H%M%S)
DESTINO=/root/backups/portfolio-wp

# --- BASE DE DATOS ---
docker exec portfolio-wp-db-1 sh -c 'mariadb-dump -u root -p"$MARIADB_ROOT_PASSWORD" --all-databases' > "$DESTINO/db_$FECHA.sql"

# --- ARCHIVOS ---
docker run --rm \
  -v portfolio-wp_wp_data:/data:ro \
  -v "$DESTINO":/backup \
  alpine tar czf "/backup/files_$FECHA.tar.gz" -C /data .

# --- LIMPIEZA ---
find "$DESTINO" -name "db_*.sql" -mtime +7 -delete
find "$DESTINO" -name "files_*.tar.gz" -mtime +7 -delete

echo "Backup completado: db_$FECHA.sql y files_$FECHA.tar.gz"
