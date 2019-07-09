#!/make
-include .env
export

build:
	#  --no-cache
	docker build -t ${BECAPE_IMAGE_NAME}/mysql:5.7 .

bash:
	docker run --rm -it\
	 -v ${PWD}/app:/var/www/app\
	 ${BECAPE_IMAGE_NAME}/mysql:5.7 bash

configure:
	docker run --rm -it\
	 -v ${PWD}/app:/var/www/app\
	 ${BECAPE_IMAGE_NAME}/mysql:5.7 configure

backup:
	docker run --rm -it\
	 -v ${PWD}/app:/var/www/app\
	 ${BECAPE_IMAGE_NAME}/mysql:5.7 backup

restore:
	docker run --rm -it\
	 -v ${PWD}/app:/var/www/app\
	 ${BECAPE_IMAGE_NAME}/mysql:5.7 restore ${BECAPE}

upload:
	docker run --rm -it\
	 -v ${PWD}/app:/var/www/app\
	 ${BECAPE_IMAGE_NAME}/mysql:5.7 upload ${BECAPE}

check:
	docker run --rm -it\
	 -v ${PWD}/app:/var/www/app\
	 ${BECAPE_IMAGE_NAME}/mysql:5.7 check

keys:
	openssl req -x509 -sha256 -nodes -newkey rsa:4096\
	 -keyout app/backup.private.pem\
	 -out app/backup.public.pem

