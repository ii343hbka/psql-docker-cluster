#!/usr/bin/env bash
set -e

echo "[repmgr/start] Waiting postgres on this node to start repmgr..."
pg_wait_db ${REPMGR_HOSTNAME} ${REPMGR_PORT} ${REPMGR_USER} ${REPMGR_PASSWORD} ${REPMGR_DB}

if [[ "x${REPMGR_UPSTREAM_HOSTNAME}" == "x" ]]; then
    REPMGR_NODE_TYPE='master'
else
    REPMGR_NODE_TYPE='standby'
fi

echo "[repmgr/start] Registering node with role ${REPMGR_NODE_TYPE}"
gosu postgres repmgr ${REPMGR_NODE_TYPE} register --force || {
  echo '[repmgr/start] register failed.'
  echo '[repmgr/start] it means either node is already registered or its really can not register'
}

echo "[repmgr/start] Starting repmgr daemon..."
rm -rf /tmp/repmgrd.pid
gosu postgres repmgrd -vvv --pid-file=/tmp/repmgrd.pid