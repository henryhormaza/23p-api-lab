#Coment this block to use a docker base layer image
#######################################################################
#This is a custom base layer in order to reduce docker build time
FROM oraclelinux:7-slim

RUN yum install -y python3
COPY ./requirements.txt /opt/requirements.txt
RUN python3 -m pip install -r /opt/requirements.txt
#######################################################################

##  Uncoment following line to build using a local baselayer Docker image 
# FROM baselayer_ol7:latest
#get dynamic vars to conect at db
WORKDIR /opt
ADD ./P23_API_LAB /opt/P23_API_LAB
COPY main.py /opt/main.py
COPY ./Terraform/output.json /opt/output.json

CMD ["python3", "/opt/main.py"]