FROM notyy/docker_hadoop:2.4.1_cluster
MAINTAINER notyycn <notyycn@gmail.com>

RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-1.0.2-bin-hadoop2.tgz
RUN tar -xzvf spark-1.0.2-bin-hadoop2.tgz -C /usr/local/
RUN rm spark-1.0.2-bin-hadoop2.tgz
RUN cd /usr/local && ln -s ./spark-1.0.2-bin-hadoop2 spark

ADD bootstrap.sh /etc/bootstrap.sh
ADD orders.csv /tmp/orders.csv
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh
ADD core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml

WORKDIR /usr/local/spark

EXPOSE 8080 8081 4040 4044
