FROM ubuntu:latest
LABEL authors="prasa"

ENTRYPOINT ["top", "-b"]