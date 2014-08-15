docker run --name=$1 -d -h=$1.spark.dev.docker --dns=172.17.42.1 notyy/spark:1.0.2_standalone /etc/bootstrap.sh -dd
