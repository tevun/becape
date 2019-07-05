FROM mysql:5.7

# Default Settings
ENV BECAPE_DIR_VOLUME "/var/www/app"
ENV BECAPE_DIR_HOME "/home/application"
ENV BECAPE_HOST ""
ENV BECAPE_PORT 3306
ENV BECAPE_DATABASE ""
ENV BECAPE_USER ""
ENV BECAPE_UID 1000

RUN adduser --quiet --home ${BECAPE_DIR_HOME} --shell /sbin/nologin --uid ${BECAPE_UID} --disabled-login application

COPY --chown=application:application ./scripts ${BECAPE_DIR_HOME}/scripts
COPY --chown=application:application ./sample ${BECAPE_DIR_HOME}/sample

RUN \
  ln -s ${BECAPE_DIR_HOME}/scripts/configure.sh /usr/bin/configure &&\
  ln -s ${BECAPE_DIR_HOME}/scripts/backup.sh /usr/bin/backup &&\
  ln -s ${BECAPE_DIR_HOME}/scripts/restore.sh /usr/bin/restore &&\
  ln -s ${BECAPE_DIR_HOME}/scripts/list.sh /usr/bin/list &&\
  mkdir -p ${BECAPE_DIR_VOLUME} &&\
  chown application:application ${BECAPE_DIR_VOLUME}

VOLUME ${BECAPE_DIR_VOLUME}

CMD /bin/bash ${BECAPE_DIR_HOME}/scripts/sample.sh && tail -f /dev/null
