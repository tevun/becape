FROM mysql:5.7

#RUN apt update &&\
#  apt install -y mysql-client
#
#RUN apt-get clean autoclean &&\
#  apt-get autoremove --yes &&\
#  rm -rf /var/lib/{apt,dpkg,cache,log}/

# Default Settings
ENV SERVICE_UID 1000

RUN adduser --quiet --home /home/application --shell /sbin/nologin --uid ${SERVICE_UID} --disabled-login application

COPY --chown=application:application ./scripts /home/application/scripts

RUN \
  ln -s /usr/bin/configure /home/application/scripts/configure.sh &&\
  ln -s /usr/bin/backup /home/application/scripts/backup.sh &&\
  ln -s /usr/bin/restore /home/application/scripts/restore.sh &&\
  mkdir -p /var/www/app &&\
  chown application:application /var/www/app

VOLUME /var/www/app
