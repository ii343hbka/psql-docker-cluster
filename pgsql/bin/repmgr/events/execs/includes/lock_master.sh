#!/usr/bin/env bash

LOCK_FILE=${PGDATA}/${REPMGR_MASTER_LOCK_FILENAME}

echo "${BAR} Locking master..."
echo "lock file is ${LOCK_FILE}"
echo "$4" > ${LOCK_FILE}