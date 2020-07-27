#Docker image to be uploaded to a repository
FROM baselayer_ol7:latest

WORKDIR /opt
ADD ./P23_API_LAB /opt/P23_API_LAB
COPY main.py /opt/main.py