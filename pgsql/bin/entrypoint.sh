#!/usr/bin/env bash
set -e
#echo '[entrypoint] STARTING SSH SERVER...'
#/usr/local/bin/cluster/ssh/start.sh

echo '[entrypoint] STARTING POSTGRES...'
/usr/local/bin/cluster/postgres/entrypoint.sh