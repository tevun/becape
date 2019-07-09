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
 -e BECAPE_MYSQL_HOST=futura-mysql\
 -e BECAPE_MYSQL_DATABASE=futura\
 -e BECAPE_MYSQL_USER=root\
 docker.hospic.io/becape/mysql:5.7
```

```bash
$ docker run --rm -d --name becape\
 --network=host\
 -v ${PWD}/app:/var/www/app\
 -v ${PWD}/app/.mylogin.cnf:/home/application/.mylogin.cnf\
 -e BECAPE_MYSQL_HOST=locahost\
 -e BECAPE_MYSQL_DATABASE=futura\
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


ln -s $(pwd)/becape.sh /usr/bin/becape