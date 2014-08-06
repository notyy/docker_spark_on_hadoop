FROM notyy/docker_hadoop:2.4.1_cluster
MAINTAINER notyycn <notyycn@gmail.com>

RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-1.0.2-bin-hadoop2.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./spark-1.0.2-bin-hadoop2 spark

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh

EXPOSE 8080
