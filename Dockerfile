FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget cmake g++-8 git libboost-program-options-dev libpng++-dev zlib1g-dev cron nginx && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
                         
ARG VER=v0.1.6

ENV TIMEFRAME="30"

ADD https://github.com/bedrock-viz/bedrock-viz/releases/download/${VER}/bedrock-viz_${VER}_linux.tar.gz .

RUN tar xzvf bedrock-viz_*_linux.tar.gz

COPY . /bedrock-viz

RUN cd /bedrock-viz && \
    mkdir build && cd build && \
    export CC=/usr/bin/gcc-8 && \
    export CXX=/usr/bin/g++-8 && \
    cmake .. && \
    make -j 4 && \
    make install && \
    rm -Rf /bedrock-viz

ADD /scripts/ /opt/scripts/

RUN line="*/"$TIMEFRAME" * * * * /opt/scripts/cron.sh" && \
    (crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -

RUN mkdir /appdata && \
    mkdir /appdata/out && \
    mkdir /appdata/world && \
    mkdir /input

RUN cp /opt/scripts/bedrock_viz.conf /etc/nginx/conf.d/

ENTRYPOINT ["/opt/scripts/start.sh"]
