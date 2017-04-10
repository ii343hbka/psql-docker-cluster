#!/usr/bin/env bash
set -e

echo "[postgres/entrypoint] check \$PGDATA dir existence"
if [[ "x$(ls ${PGDATA}/ | wc -l)" != "x0" ]]; then
  echo "[postgres/entrypoint] Data folder is not empty $PGDATA:"
  ls -al "${PGDATA}"
  
  if [[ "${PG_FORCE_CLEAN}" == "1" ]] || ! pg_has_cluster; then
    echo "[postgres/entrypoint] \$PG_FORCE_CLEAN is set"
    echo "[postgres/entrypoint] Cleaning data folder..."
    rm -rf "${PGDATA}"/*
  fi
fi
chown -R postgres "${PGDATA}" && chmod -R 0700 "${PGDATA}"

echo '[postgres/entrypoint] build repmgr config'
/usr/local/bin/cluster/repmgr/configure.sh

echo "[postgres/entrypoint] Setting up postgres..."
if [[ "x${REPMGR_UPSTREAM_HOSTNAME}" == "x" ]]; then
  echo "[postgres/entrypoint] no \$REPMGR_UPSTREAM_HOSTNAME set, thus this ought to be master"
  echo "[postgres/entrypoint] copy /usr/local/bin/cluster/postgres/master/entrypoint.sh to /docker-entrypoint-initdb.d/"
  # same logic as run-parts
  # entrypoint.sh at /docker-entrypoint-initdb.d/ will be invoked by /docker-entrypoint.sh
  cp -f /usr/local/bin/cluster/postgres/master/entrypoint.sh /docker-entrypoint-initdb.d/
  # same entrypoint as in official postgres docker image
  echo '[postgres/entrypoint] start postgres at background...'
  /docker-entrypoint.sh postgres &
else
  /usr/local/bin/cluster/postgres/slave/entrypoint.sh &
fi

echo '[postgres/entrypoint] start repmgr'
/usr/local/bin/cluster/repmgr/start.sh