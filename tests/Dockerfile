FROM ubuntu:16.04

ENV PATCHDATE 20180612

RUN apt-get update && apt-get -y upgrade && apt-get -y install software-properties-common

RUN add-apt-repository ppa:duggan/bats && apt-get upgrade && apt-get install bats

VOLUME /tests

COPY . /tests

ENTRYPOINT [ "/usr/bin/bats" ]

CMD [ "/tests" ]