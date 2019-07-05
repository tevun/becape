build:
	#  --no-cache
	docker build -t docker.hospic.io/becape/mysql:5.7 .

sh:
	docker run --rm -it mysqldump-secure sh

bash:
	docker run --rm -it\
	 -v ${PWD}/etc/mysqldump-secure.cnf:/etc/mysqldump-secure.cnf\
	 mysqldump-secure bash

run:
	docker run --rm -it mysqldump-secure mysqldump-secure

test:
	docker run --rm -it\
	 -v ${PWD}/etc/mysqldump-secure.cnf:/etc/mysqldump-secure.cnf\
	 mysqldump-secure mysqldump-secure --test -vv

keys:
	openssl req -x509 -sha256 -nodes -newkey rsa:4096 -keyout sample/backup.private.pem -out sample/backup.public.pem