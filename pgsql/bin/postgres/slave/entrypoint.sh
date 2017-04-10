#!/usr/bin/env bash
set -e

echo "[slave/entrypoint] Waiting for master node..."
pg_wait_db ${REPMGR_UPSTREAM_HOSTNAME} ${REPMGR_PORT} ${REPMGR_USER} ${REPMGR_PASSWORD} ${REPMGR_DB}

echo "[slave/entrypoint] Starting slave node..."
if ! pg_has_cluster; then
    echo "[slave/entrypoint] Instance hasn't been set up yet. Clonning primary node..."
    PGPASSWORD=${REPMGR_PASSWORD} gosu postgres repmgr -h ${REPMGR_UPSTREAM_HOSTNAME} -U ${REPMGR_USER} -d ${REPMGR_DB} -D ${PGDATA} standby clone --fast-checkpoint --force
fi

echo "[slave/entrypoint] Starting postgres..."
exec gosu postgres postgres