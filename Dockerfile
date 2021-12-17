FROM python:3.8-slim
MAINTAINER Tillmann Heidsieck <theidsieck@leenox.de>
EXPOSE 8080
VOLUME [ "/var/iota" ]

COPY requirements.txt /requirements.txt
RUN python3 -m pip install -r /requirements.txt && rm /requirements.txt

RUN apt-get update -yqq && apt-get dist-upgrade -yqq && apt-get install -yqq \
	build-essential \
	git \
	libffi-dev  \
	sqlite3

ARG IOTA_BRANCH=origin/main
RUN git clone https://github.com/owsf/owsf-ota-server /usr/src/owsf-ota-server \
	&& cd /usr/src/owsf-ota-server \
	&& git checkout ${IOTA_BRANCH} \
	&& python3 -m pip install -r requirements.txt \
	&& python3 setup.py install \
	&& cd / \
	&& rm -rf /usr/src/owsf-ota-server \
	&& rm -rf /root/.cache

RUN apt-get purge -yqq build-essential libffi-dev git && apt-get autoremove -yqq && rm -rf /var/cache/apt

RUN mkdir -p /var/iota/.local && useradd -s /bin/bash -d /var/iota -M iota

COPY run.sh /usr/bin/run.sh

ENTRYPOINT ["/usr/bin/run.sh"]
