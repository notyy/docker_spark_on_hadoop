# docker_spark_on_hadoop

### 前提条件
* 已安装好[docker](www.docker.com)
* 机器内存大于等于***8G***——主要spark比较吃内存
  * 如果使用Mac或windows，请打开virtualbox，将里面正在运行的boot2docker-vm虚拟机的内存设置到6G以上
* 初次使用时会下载docker image文件，大约1G多，所以注意确保磁盘空间和***网络流量***

### 启动步骤
1. git clone https://github.com/notyy/docker_spark_on_hadoop.git
2. cd docker_spark_on_hadoop/1.0.2/standalone
3. 检查目录下的.sh文件是否具有执行权限（***bootstrap.sh除外***）
4. 运行./skydns.sh启动dns服务，第一次使用时会自动pull skydns image
5. 运行./skydock.sh，此容器会自动监听docker容器的起停命令，从而自动更新dns，第一次使用会自动pull skydock image
6. 运行./startmaster_i.sh，会启动安装好hadoop和spark的docker容器，并自动启动namenode,resourceManager和spark master，然后进入bash终端，方便之后在这个节点上进行hadoop和spark操作，第一次运行时会pull一个1G多的image
7. 此时打开http://localhost:50070 应该可以看到hadoop的web管理界面
  * ***注意***如果你在mac或者windows上操作，由于docker只支持linux，所以在非Linux操作系统上实际上是起了一个virtualbox，在virtualbox里的linux上运行的docker，
  因此端口绑定的是这个虚拟机的ip而不是主机的ip，所以要运行`boot2docker ip`来查看虚拟机的ip地址，一般是`192.168.59.103`, 所以可以用http://192.168.59.103:50070 来访问hadoop管理界面
8. 此时在overview的信息里应该看到live node数为0,在data nodes TAB里应该看不到data node，因为尚未启动data node
9. 此时打开http://localhost:8080 或 http://192.168.59.103:8080 应该可以看到spark的管理界面，worker列表里为空
10. 另开一个终端，在该终端下运行./startslave_d.sh datanode1
  * ***注意***如果mac或windows下报错，你可能需要在该终端里再运行一次boot2docker start
11. 几秒后（*时间取决于你的机器配置*）刷新hadoop管理界面，应该看到多了一个datanode，刷新spark管理界面应该看到多了一个worker
12. 启动更多的datanode, 每次执行./startslave_d.sh ***数据节点的名字***即启动一个数据节点，数据节点的名字不能重复，每个节点目前配置1G内存，所以注意你的内存，一般学习测试使用一共起3个即可
13. 验证hadoop和spark管理界面，确认数据节点都已启动并接入
14. 在前一个终端的namenode交互终端里，当前路径应该是/usr/local/spark，hadoop的安装路径在/usr/local/hadoop，所以执行以下命令来准备一些数据：
```
../hadoop/bin/hdfs dfs -mkdir /test
../hadoop/bin/hdfs dfs -put ../hadoop/etc/hadoop/*.xml /test
```
15. 执行`bin/spark-shell --master spark://namenode.spark.dev.docker:7077`启动spark shell
  * 观察启动过程的日志，看是否连接了worker，创建了executor
  * ***注意***执行过程中可能会看上去卡死在`register executor`的地方，此时其实已经启动完，敲回车即可进入提示符，开始输入命令
16. 查看spark管理界面应该可以看到每个work分配的1G内存被占用了512M内存
17. 查看http://localhost:4040 或 http://192.168.59.103:4040，可以看到spark-shell的监控界面，可在此处查看命令的执行情况
18. 在spark shell终端里输入以下命令

```
val data = sc.textFile("hdfs://namenode.spark.dev.docker:9000/test").persist()
val data.count
```

19. 应该可以看到count的输出，并且可以在4040端口的spark shell界面上看到数据在内存中占用了多少空间， persist命令在第一次调用count时才生效， 此时再运行`data.count`，应该会极快的给出结果
20. 开始自己玩呗
