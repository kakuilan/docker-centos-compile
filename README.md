# docker-centos-compile
docker-centos-compile CentOS编译包镜像

### 构建本地镜像
```shell
sudo docker build -t mycent .
sudo docker build --add-host raw.githubusercontent.com:185.199.108.133 -t mycent .
```

### 发布镜像
```shell
sudo docker tag mycent:latest kakuilan/centos-compile:0.0.2
sudo docker login
sudo docker push kakuilan/centos-compile:0.0.2
```