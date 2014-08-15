docker run -ti --rm --dns=172.17.42.1 --name=$1 -h=$1.spark.dev.docker notyy/spark:1.0.2_standalone /etc/bootstrap.sh -bashd
