FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends gcc gcc-multilib vim sysbench \
    && rm -rf /var/lib/apt/lists/*
\

RUN apt update
RUN apt-get install -yqq fio

COPY sync_loop.sh /app/

WORKDIR /app