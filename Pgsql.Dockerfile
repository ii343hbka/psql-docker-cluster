FROM postgres:9.6
ARG POSTGRES_VERSION=9.6

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

RUN apt-get update && apt-get install -y postgresql-server-dev-$POSTGRES_VERSION postgresql-$POSTGRES_VERSION-repmgr openssh-server

# Need SSH for cross connections
# SSH login fix. Otherwise user is kicked off after login
#RUN mkdir /var/run/sshd && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd



# --
# POSTGRESQL
# --
#
# Inherited variables from base image
#
#ENV POSTGRES_PASSWORD monkey_pass
#ENV POSTGRES_USER monkey_user
#ENV POSTGRES_DB monkey_db

# String with custom options for postgresql.conf
# comma separated format variable1:value1[,variable2:value2[,...]]
# ENV PG_CUSTOM_CONFIG "listen_addresses:'*'"

# Clean $PGDATA directory before start
#ENV PG_FORCE_CLEAN 0



# --
# REPMGR
# --
# hostname for pg replication upstream host
# this variable controls whether this instance will be master or slave
# of not set, than master
#
#ENV REPMGR_UPSTREAM_HOSTNAME

# hostname for repmgr psql connection
# will be substituted in conninfo='' at repmgr.conf
#ENV REPMGR_HOSTNAME=node1

# repmgr database for cluster info
#ENV REPMGR_DB repmgr
#ENV REPMGR_USER repmgr
#ENV REPMGR_PASSWORD repmgr
#ENV REPMGR_PORT 5432
#ENV REPMGR_CONNECT_TIMEOUT 1

#ENV REPMGR_CLUSTER_NAME=pg_cluster

#ENV REPMGR_NODE_ID 1
#ENV REPMGR_NODE_NAME node1 
#ENV REPMGR_RECONNECT_ATTEMPTS 5
#ENV REPMGR_RECONNECT_INTERVAL 1
#ENV REPMGR_MASTER_RESPONSE_TIMEOUT 5
#ENV REPMGR_LOG_LEVEL INFO

# File will be put in $PGDATA/$REPMGR_LOCK_FILENAME when:
#    - node starts as a primary node/master
#    - node promoted to a primary node/master
# File does not exist
#    - if node starts as a standby
#ENV REPMGR_MASTER_LOCK_FILENAME $PGDATA/master.lock



# --
# AUX
# --
#ENV WAIT_MAX_TRIES 10
#ENV WAIT_SLEEP_TIME 2



COPY ./pgsql/bin /usr/local/bin/cluster
RUN chmod -R +x /usr/local/bin/cluster && \
    ln -s /usr/local/bin/cluster/aux/* /usr/local/bin
COPY ./pgsql/configs /var/cluster_configs
COPY ./pgsql/ssh /home/postgres/.ssh

VOLUME /var/lib/postgresql/data
USER root

CMD ["/usr/local/bin/cluster/entrypoint.sh"]
