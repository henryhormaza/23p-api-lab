FROM oraclelinux:7-slim
RUN yum install -y python3
COPY ./requirements.txt /opt/requirements.txt
RUN python3 -m pip install -r /opt/requirements.txt
WORKDIR /opt
ADD ./P23_API_LAB /opt/P23_API_LAB
COPY main.py /opt/main.py
COPY ./Terraform/output.json /opt/output.json

CMD ["python3", "/opt/main.py"]