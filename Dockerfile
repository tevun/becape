FROM mysql:5.7

# Default Settings
ENV BACKUP_UID 1000

RUN adduser --quiet --home /home/application --shell /sbin/nologin --uid ${BACKUP_UID} --disabled-login application

COPY --chown=application:application ./scripts /home/application/scripts
COPY --chown=application:application ./sample /home/application/sample

RUN \
  ln -s /home/application/scripts/configure.sh /usr/bin/configure &&\
  ln -s /home/application/scripts/backup.sh /usr/bin/backup &&\
  ln -s /home/application/scripts/restore.sh /usr/bin/restore &&\
  mkdir -p /var/www/app &&\
  chown application:application /var/www/app

VOLUME /var/www/app

CMD /bin/bash /home/application/scripts/sample.sh && tail -f /dev/null
