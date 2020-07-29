#get dynamic vars to conect at db
ARG LOCAL_VAR_LAB_DB_IP=""
ARG LOCAL_VAR_LAB_DB_USER=""
ARG LOCAL_VAR_LAB_DB_PWD=""
ARG LOCAL_VAR_LAB_DB_NAME=""

#Coment this block to use a docker base layer image
#######################################################################
#This is a custom base layer in order to reduce docker build time
FROM oraclelinux:7-slim

RUN yum install -y python3
COPY ./requirements.txt /opt/requirements.txt
RUN python3 -m pip install -r /opt/requirements.txt
#######################################################################

# #  Uncoment following line to build using a local baselayer Docker image 
# FROM baselayer_ol7:latest

WORKDIR /opt
ADD ./P23_API_LAB /opt/P23_API_LAB
COPY main.py /opt/main.py
RUN ["echo", $LOCAL_VAR_LAB_DB_IP]
ENV VAR_lab_DB_IP=$LOCAL_VAR_LAB_DB_IP VAR_lab_DB_USER="test" VAR_lab_DB_PWD=$LOCAL_VAR_LAB_DB_PWD VAR_lab_DB_NAME=$LOCAL_VAR_LAB_DB_NAME 

CMD ["python3", "/opt/main.py"]