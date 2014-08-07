#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
export SPARK_HOME=/usr/local/spark

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

service ssh start

if [[ $1 == "-nd" ]]; then
  $HADOOP_PREFIX/bin/hdfs namenode -format
  $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
  $HADOOP_PREFIX/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
  $HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR
  $SPARK_HOME/sbin/start-master.sh
  while true; do sleep 1000; done
fi

if [[ $1 == "-dd" ]]; then
  $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start datanode
  $HADOOP_PREFIX/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start nodemanager
  $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://namenode:7077 -c 2 -m 400M
  while true; do sleep 1000; done
fi

if [[ $1 == "-bashn" ]]; then
  $HADOOP_PREFIX/bin/hdfs namenode -format
  $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
  $HADOOP_PREFIX/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
  $HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR
  $SPARK_HOME/sbin/start-master.sh
  /bin/bash
fi

if [[ $1 == "-bashd" ]]; then
  $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start datanode
  $HADOOP_PREFIX/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start nodemanager
  $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://namenode:7077 -c 2 -m 400M
  /bin/bash
fi
