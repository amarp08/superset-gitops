FROM apache/superset:latest

USER root

# Install requirements for MySQL connectivity
RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev build-essential pkg-config && \
    pip install mysqlclient

USER superset