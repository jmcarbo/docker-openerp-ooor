# openerp app with ooor
#

# openerp app
#
# Usage: docker run dpaw/openerp [provisionAndRun|run|provision]
#
# Description: based on
#              http://www.theopensourcerer.com/2012/12/how-to-install-openerp-7-0-on-ubuntu-12-04-lts/
#
# Sets: 
#
# Exposes: 8080/openerp
#

FROM ubuntu:12.04
MAINTAINER Joan Marc Carbo Arnau <jmcarbo@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -q -y language-pack-en
RUN update-locale LANG=en_US.UTF-8

RUN apt-get install -q -y vim

# project settings
ENV project_name openerp
ENV project_root /home/openerp/
ENV project_url http://nightly.openerp.com/7.0/nightly/src/openerp-7.0-latest.tar.gz

RUN adduser --system --home=$project_root --group openerp && \
    apt-get -y install python-dateutil python-docutils python-feedparser \
        python-gdata python-jinja2 python-libxslt1 \
        python-mako python-mock python-openid python-psutil \
        python-pybabel python-pychart python-pydot python-pyparsing \
        python-simplejson python-tz python-unittest2 \
        python-vatnumber python-vobject python-webdav python-werkzeug \
        python-xlwt python-yaml python-zsi python-reportlab python-psycopg2 \
        postgresql-client-9.1 python-cups python-django-auth-ldap git

RUN apt-get -y install wget sudo bzip2

RUN    wget https://wkhtmltopdf.googlecode.com/files/wkhtmltoimage-0.11.0_rc1-static-amd64.tar.bz2 && \
    wget https://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.11.0_rc1-static-amd64.tar.bz2 && \
    bzip2 -d wkhtmltoimage-0.11.0_rc1-static-amd64.tar.bz2 && \
    tar xvf wkhtmltoimage-0.11.0_rc1-static-amd64.tar && \
    bzip2 -d wkhtmltopdf-0.11.0_rc1-static-amd64.tar.bz2 && \
    tar xvf wkhtmltopdf-0.11.0_rc1-static-amd64.tar && \
    install wkhtmltopdf-amd64 /usr/bin/wkhtmltopdf && \
    install wkhtmltoimage-amd64 /usr/bin/wkhtmltoimage 

#RUN useradd openerp
RUN adduser openerp sudo
RUN echo openerp:vagrant | chpasswd
RUN cd / && \
    git clone https://github.com/jmcarbo/openerp7.git && \
    chown -R openerp: openerp7 && \
    ln -s openerp7/ openerp-server

RUN apt-get -y install build-essential git autoconf libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev python-pip libzmq-dev python-all-dev
RUN apt-get -y install build-essential libffi-dev libreadline-dev libyaml-dev zlib1g-dev ;\
  apt-get -y install libsqlite3-dev libmysqlclient-dev libmemcached-dev libmagickwand-dev ;\
  apt-get -y install libev-dev libevent-dev ;\
  apt-get -y install libssl-dev libcurl4-openssl-dev curl openssl ca-certificates ;\
  apt-get -y install libxml2 libxml2-dev libxslt1-dev 
RUN wget -O /usr/local/src/ruby.tgz http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.0.tar.gz 
RUN   cd /usr/local/src && \
  tar zxvf /usr/local/src/ruby.tgz && \
  cd /usr/local/src/ruby-2.1.0 && ./configure && make install
RUN pip install circus
RUN pip install circus-web
RUN echo "END"
    
ADD circus.ini /circus.ini
#ADD startup.sh ~/startup.sh

CMD ["circusd /circus.ini"]
EXPOSE 8069 8080 5000 5555 5556 5557
#USER openerp
