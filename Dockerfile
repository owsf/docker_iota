FROM python:alpine
MAINTAINER Tillmann Heidsieck <theidsieck@leenox.de>
EXPOSE 8080
VOLUME [ "/var/iota" ]

COPY requirements.txt /requirements.txt
RUN python3 -m pip install -r /requirements.txt && rm /requirements.txt

RUN apk add --no-cache --virtual .fetch-deps \
	git \
	&& git clone https://github.com/junkdna/esp8266-control-server.git /usr/src/esp8266-control-server -b impl \
	&& apk del --no-network .fetch-deps \
	&& cd /usr/src/esp8266-control-server \
	&& apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		libffi-dev \
		make \
	\
	&& python3 -m pip install -r requirements.txt \
	&& python3 setup.py install \
	&& apk del --no-network .build-deps \
	&& cd / \
	&& rm -rf /usr/src/esp8266-control-server \
	&& rm -rf /root/.cache \
	&& apk add sqlite bash


COPY run.sh /usr/bin/run.sh
RUN mkdir /var/iota && adduser -s /bin/bash -h /var/iota -D iota 

ENTRYPOINT ["/usr/bin/run.sh"]
