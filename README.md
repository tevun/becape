# Becape

## Usage

### Use with docker run

#### Start container

Use a command like below to start a new container called `becape`
```bash
# from docker-compose project or global network
# volume to manipulate backup files
# volume to previous saved credentials
# env variable to mysql host target
# env variable to mysql database target
# user who will be used in commands
# the image name
$ docker run --rm -d --name becape\
 --network=api_default\
 -v ${PWD}/app:/var/www/app\
 -v ${PWD}/app/.mylogin.cnf:/home/application/.mylogin.cnf\
 -e BECAPE_MYSQL_HOST=project-mysql\
 -e BECAPE_MYSQL_DATABASE=project\
 -e BECAPE_MYSQL_USER=root\
 docker.hospic.io/becape/mysql:5.7
```

```bash
$ docker run --rm -d --name becape\
 --network=host\
 -v ${PWD}/app:/var/www/app\
 -v ${PWD}/app/.mylogin.cnf:/home/application/.mylogin.cnf\
 -e BECAPE_MYSQL_HOST=locahost\
 -e BECAPE_MYSQL_DATABASE=project\
 -e BECAPE_MYSQL_USER=root\
 docker.hospic.io/becape/mysql:5.7
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
  # project-backup
  project-backup:
    image: docker.hospic.io/becape/mysql:5.7
    restart: always
    container_name: project-backup
    working_dir: /var/www/app
    user: application
    volumes:
      - .docker/project-backup/storage:/var/www/app
    #  - .docker/project-backup/storage/.mylogin.cnf:/home/application/.mylogin.cnf
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
mkdir .docker/project-backup/storage
docker-compose up -d project-backup
cat docker-compose.yml # jut to show the container settings 
docker exec -it project-backup configure # type the password used in mysql container
```

Add connection file as container volume and download public certificate
```bash
docker-compose stop project-backup
docker-compose rm project-backup
mv .docker/project-backup/storage/.mylogin.cnf.xxx .docker/project-backup/storage/.mylogin.cnf
nano docker-compose.yml # uncomment  - .docker/project-backup/storage/.mylogin.cnf:/home/application/.mylogin.cnf
wget http://89.207.131.43/project/backup.public.pem -O .docker/project-backup/storage/backup.public.pem
docker-compose up -d project-backup
```

Configure cron using `crontab -e`
```bash
00 02 * * * /usr/bin/docker exec futura-backup cron > /domains/app.futuragenetics.com/futura-backup.log
```

### Configure server

#### Download and configure

Go to home of user, the directory `~` and follow the next steps.
```bash
mkdir ~/becape/ && \
wget http://89.207.131.43/becape.zip && \
unzip becape.zip -d ~/becape && \
cd ~/becape/ && \
sudo ln -s $(pwd)/becape.sh /usr/bin/becape
```

Start the http serve
```bash
cd ~/becape/ && \
touch run && \
chmod +x run && \
echo > ""
```


#### 