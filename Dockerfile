FROM lambci/lambda\:build-python3.8

RUN yum install -y mysql-devel