#!/make
-include .env
export

build:
	#  --no-cache
	docker build -t ${BECAPE_IMAGE_NAME}/mysql:5.7 .
	docker push ${BECAPE_IMAGE_NAME}/mysql:5.7

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

zip:
	git archive --format zip --output becape.zip master
	scp -P 10222 becape.zip dev@89.207.131.43:/home/dev/becape/becape.zip
