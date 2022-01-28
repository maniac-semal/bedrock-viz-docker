FROM ubuntu:18.04 as builder
MAINTAINER maniac_semal

ARG VER=v0.1.6
ENV TIMEFRAME="30"

RUN apt-get update && \
    apt-get install -y wget cmake libpng++-dev zlib1g-dev libboost-program-options-dev g++-8 cron && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://github.com/bedrock-viz/bedrock-viz/releases/download/${VER}/bedrock-viz_${VER}_linux.tar.gz .

RUN tar xzvf bedrock-viz_*_linux.tar.gz

RUN cd /bedrock-viz && \
    mkdir build && cd build && \
    export CC=/usr/bin/gcc-8 && \
    export CXX=/usr/bin/g++-8 && \
    cmake .. && \
    make -j 4 && \
    make install && \
    rm -Rf /bedrock-viz

ADD /scripts/ /opt/scripts/

RUN line="*/"$TIMEFRAME" * * * * /opt/scripts/start.sh" && \
    (crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -

RUN mkdir /out && \
    mkdir /world && \
    mkdir /input

ENTRYPOINT ["/opt/scripts/start.sh"]
