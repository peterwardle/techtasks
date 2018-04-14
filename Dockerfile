FROM ubuntu:16.04
RUN apt-get -q -y --fix-missing update && apt-get -q -y install cron wget puppet
