FROM ubuntu:20.04
MAINTAINER Tillmann Heidsieck <theidsieck@leenox.de>
EXPOSE 8080

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get dist-upgrade -yqq && apt-get install -yqq \
	tzdata \
	python3 \
	python3-flask \
	python3-flask-api \
	python3-wheel \
	python3-waitress \
	python3-setuptools \
	python3-distutils \
	python3-packaging \
	supervisor \
	git

RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
	dpkg-reconfigure --frontend noninteractive tzdata

RUN useradd -s /bin/bash -r -M -d /opt/iota iota
RUN git clone https://github.com/junkdna/esp8266-control-server.git /usr/src/esp8266-control-server && \
	cd /usr/src/esp8266-control-server && \
	python3 setup.py install


COPY run.sh /usr/bin/run.sh
COPY supervisord.conf /etc/supervisord.conf

VOLUME ["/opt/iota/iota-instance"]

ENTRYPOINT ["/usr/bin/run.sh"]
