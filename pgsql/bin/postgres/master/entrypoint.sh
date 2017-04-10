#!/usr/bin/env bash
set -e
/usr/local/bin/cluster/postgres/master/build-custom-config.sh

echo "[master/entrypoint] Creating replication user '${REPMGR_USER}'"
psql --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" -c "CREATE ROLE ${REPMGR_USER} WITH REPLICATION PASSWORD '${REPMGR_PASSWORD}' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;"

echo "[master/entrypoint] Creating replication db '${REPMGR_DB}'"
createdb ${REPMGR_DB} -O ${REPMGR_USER}

#TODO: make it more flexible, allow set of IPs
echo "host replication ${REPMGR_USER} 0.0.0.0/0 md5" >> "${PGDATA}/pg_hba.conf"