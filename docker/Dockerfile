FROM ubuntu-debootstrap:14.04

RUN apt-get update
RUN apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev postgresql-server-dev-9.3 imagemagick nodejs

ADD ./setup.sh /tmp/setup.sh
RUN chmod 755 /tmp/setup.sh
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive /tmp/setup.sh

ADD ./rails.sh /root/
RUN chmod 755 ~/rails.sh

ADD ./sinatra.sh /root/
RUN chmod 755 ~/sinatra.sh