#!/usr/bin/env bash
set -e

echo "[repmgr/configure] Setting up repmgr..."
REPMGR_CONFIG_FILE=/etc/repmgr.conf
cp -f /var/cluster_configs/repmgr.conf "${REPMGR_CONFIG_FILE}"

echo "[repmgr/configure] Setting up repmgr config file '${REPMGR_CONFIG_FILE}'..."
echo "
pg_bindir=/usr/lib/postgresql/${PG_MAJOR}/bin
cluster=${REPMGR_CLUSTER_NAME}
node=${REPMGR_NODE_ID}
node_name=${REPMGR_NODE_NAME}
conninfo='user=${REPMGR_USER} password=${REPMGR_PASSWORD} host=${REPMGR_HOSTNAME} dbname=${REPMGR_DB} port=${REPMGR_PORT} connect_timeout=${REPMGR_CONNECT_TIMEOUT}'
failover=automatic
promote_command='PGPASSWORD=${REPMGR_PASSWORD} repmgr standby promote --log-level DEBUG --verbose'
follow_command='PGPASSWORD=${REPMGR_PASSWORD} repmgr standby follow -W --log-level DEBUG --verbose'
reconnect_attempts=${REPMGR_RECONNECT_ATTEMPTS}
reconnect_interval=${REPMGR_RECONNECT_INTERVAL}
master_response_timeout=${REPMGR_MASTER_RESPONSE_TIMEOUT}
loglevel=${REPMGR_LOG_LEVEL}
" >> "${REPMGR_CONFIG_FILE}"

chown postgres "${REPMGR_CONFIG_FILE}"