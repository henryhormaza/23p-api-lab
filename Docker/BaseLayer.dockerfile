#This is a custom base layer in order to reduce docker build time
FROM oraclelinux:7-slim

RUN yum install -y python3
COPY ./requirements.txt /opt/requirements.txt
RUN python3 -m pip install -r /opt/requirements.txt