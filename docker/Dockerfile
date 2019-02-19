FROM python:2.7
MAINTAINER MeMyselfAndI

# Creating Application Source Code Directory
RUN mkdir -p /k8s_python/src

# Setting Home Directory for containers
WORKDIR /k8s_python/src

# Installing python dependencies
#COPY requirements.txt /k8s_python/src
#RUN pip install --no-cache-dir -r requirements.txt

# Copying src code to Container
COPY *.sh /k8s_python/src/app/
COPY *.py /k8s_python/src/app/
COPY *.ico /k8s_python/src/

# Application Environment variables
ENV APP_ENV development

# Exposing Ports
EXPOSE 8081

# Setting Persistent data
VOLUME ["/app-data"]

# Running Python Application
CMD ["/bin/sh", "/k8s_python/src/app/run.sh"]
