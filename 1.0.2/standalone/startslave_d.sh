docker run --name=$1 -d -h=$1 --link namenode:namenode notyy/docker_spark_on_hadoop:1.0.2_standalone /etc/bootstrap.sh -dd
