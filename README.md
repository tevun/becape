# Becape

## Usage

### Use with docker run

#### Start container

Use a command like below to start a new container called `becape`
```bash
$ docker run --rm -d\
 --name becape\
 --network=<project-backup>\
 -v ${PWD}/app:/var/www/app\
 -v ${PWD}/app/.mylogin.cnf:/home/application/.mylogin.cnf\
 -e BECAPE_MYSQL_HOST=<project-backup>\
 -e BECAPE_MYSQL_DATABASE=<project-backup>\
 -e BECAPE_MYSQL_USER=root\
 becape/mysql:5.7

# --network: from docker-compose project or global network
# -v (${PWD}/app:/var/www/app): volume to manipulate backup files
# -v (${PWD}/app/.mylogin.cnf:/home/application/.mylogin.cnf): volume to previous saved credentials
# -e (BECAPE_MYSQL_HOST): env variable to mysql host target
# -e (BECAPE_MYSQL_DATABASE): env variable to mysql database target
# -e (BECAPE_MYSQL_USER): user who will be used in commands
# [becape/mysql:5.7]: the image name, it depends of build
```

#### Configure connection

Excute `configure` command to create the `.mylogin.cnf` container directory in `/home/application`.
When this command is executed the new `.mylogin.cnf` is copied to volume that was created to manipulate backup files
(it is possible use `.mylogin.cnf` as a volume to `/home/application/.mylogin.cnf` to reuse the created settings).
```bash
$ docker exec -it becape configure
```

#### Create backup

```bash
$ docker exec -it becape backup
```

### Handling with build

#### Configure the env variable inline

```bash
export BECAPE_IMAGE_NAME=registry.my-company.com/becape && make build
```

#### Configure the env variables in .env

```bash
cp .env.sample .env
nano .env # change the value of BECAPE_IMAGE_NAME property
```

### Installation

#### Using as image

Add the service in docker-compose.yml
```yaml
  # <project-backup>
  <project-backup>:
    image: becape/mysql:5.7
    restart: always
    container_name: <project-backup>
    working_dir: /var/www/app
    user: application
    volumes:
      - .docker/<project-backup>/storage:/var/www/app
      - .docker/<project-backup>/storage/.mylogin.cnf:/home/application/.mylogin.cnf
    depends_on:
      - project-mysql
    links:
      - project-mysql
    environment:
      - BECAPE_MYSQL_HOST=project-mysql
      - BECAPE_MYSQL_DATABASE=project
      - BECAPE_MYSQL_USER=root
      - BECAPE_MINIO_PROTOCOL=http
      - BECAPE_MINIO_HOST=89.207.131.43
      - BECAPE_MINIO_PORT=9000
      - BECAPE_MINIO_KEY=xxx
      - BECAPE_MINIO_SECRET=xxx
      - BECAPE_MINIO_BUCKET=xxx
```

Configure connection
```bash
mkdir -p '.docker/<project-backup>/storage' && \
touch '.docker/<project-backup>/storage/.mylogin.cnf' && \
chmod 600 '.docker/<project-backup>/storage/.mylogin.cnf' && \
docker-compose up -d '<project-backup>' && \
cat docker-compose.yml && \ 
docker exec -it '<project-backup>' configure # type the password used in mysql container
```

Add connection file as container volume and download public certificate
```bash
wget --user <user> --password <password> http://89.207.131.43/<project-backup>/backup.public.pem -O .docker/<project-backup>/storage/backup.public.pem
```

Configure cron using `crontab -e`
```
00 02 * * * /usr/bin/docker exec <project-backup> cron > /projects/project/<project-backup>.log
```

### Configure server

#### Download and configure

Go to home of user, the directory `~` and follow the next steps.
```bash
mkdir ~/becape/ && \
wget --user <user> --password <password> http://89.207.131.43/becape.zip && \
unzip becape.zip -d ~/becape && \
cd ~/becape/ && \
sudo ln -s $(pwd)/becape.sh /usr/bin/becape
```

Start the httpd server and configure an user and password
```
bash ~/becape/bin/httpd.sh && \
docker exec -it becape-httpd htpasswd -c /usr/local/apache2/htppd.passwd <user>
```

Start the storage server
```bash
bash ~/becape/bin/minio.sh
```
