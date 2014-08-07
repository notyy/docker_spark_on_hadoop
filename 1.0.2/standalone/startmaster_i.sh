docker run -ti --rm --name=namenode -h=namenode -p 8080:8080 -p 4040:4040 -p 50070:50070 -p 8088:8088 -p 19888:19888 notyy/docker_spark_on_hadoop:1.0.2_standalone /etc/bootstrap.sh -bashn
