FROM mysql:5.7

RUN apt-get update &&\
  apt-get install -y nano curl wget

RUN apt-get clean autoclean &&\
  apt-get autoremove --yes &&\
  rm -rf /var/lib/{apt,dpkg,cache,log}/

# Default Settings
ENV BECAPE_DIR_VOLUME "/var/www/app"
ENV BECAPE_DIR_DATA "${BECAPE_DIR_VOLUME}/data"
ENV BECAPE_DIR_HOME "/home/application"
ENV BECAPE_UID 1000

ENV BECAPE_LOGIN_PATH "becape"

ENV BECAPE_MYSQL_HOST ""
ENV BECAPE_MYSQL_PORT 3306
ENV BECAPE_MYSQL_DATABASE ""
ENV BECAPE_MYSQL_USER ""

ENV BECAPE_MINIO_PROTOCOL "https"
ENV BECAPE_MINIO_HOST ""
ENV BECAPE_MINIO_PORT 9000
ENV BECAPE_MINIO_KEY ""
ENV BECAPE_MINIO_SECRET ""
ENV BECAPE_MINIO_BUCKET ""

RUN adduser --quiet --home ${BECAPE_DIR_HOME} --shell /sbin/nologin --uid ${BECAPE_UID} --disabled-login application

RUN \
  mkdir -p ${BECAPE_DIR_HOME}/becape &&\
  chown application:application ${BECAPE_DIR_HOME}/becape

COPY --chown=application:application ./becape.sh ${BECAPE_DIR_HOME}/becape/becape.sh
COPY --chown=application:application ./scripts ${BECAPE_DIR_HOME}/becape/scripts
COPY --chown=application:application ./sample ${BECAPE_DIR_HOME}/becape/sample

COPY --chown=application:application ./docker ${BECAPE_DIR_HOME}/becape/docker

RUN \
  ln -s ${BECAPE_DIR_HOME}/becape/becape.sh /usr/bin/becape &&\
  ln -s ${BECAPE_DIR_HOME}/becape/scripts/backup.sh /usr/bin/backup &&\
  ln -s ${BECAPE_DIR_HOME}/becape/scripts/configure.sh /usr/bin/configure &&\
  ln -s ${BECAPE_DIR_HOME}/becape/scripts/cron.sh /usr/bin/cron &&\
  ln -s ${BECAPE_DIR_HOME}/becape/scripts/list.sh /usr/bin/list &&\
  ln -s ${BECAPE_DIR_HOME}/becape/scripts/restore.sh /usr/bin/restore &&\
  ln -s ${BECAPE_DIR_HOME}/becape/scripts/upload.sh /usr/bin/upload

RUN \
  mkdir -p ${BECAPE_DIR_VOLUME} &&\
  chown application:application ${BECAPE_DIR_VOLUME}

VOLUME ${BECAPE_DIR_VOLUME}

USER application

CMD /bin/bash ${BECAPE_DIR_HOME}/becape/docker/sample.sh && tail -f /dev/null
