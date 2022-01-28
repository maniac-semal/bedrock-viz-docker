FROM ubuntu:20.04 as builder
MAINTAINER maniac_semal

ARG VER=v0.1.6
ENV TIMEFRAME="30"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake g++ git libboost-program-options-dev libpng++-dev zlib1g-dev

ADD https://github.com/bedrock-viz/bedrock-viz/releases/download/${VER}/bedrock-viz_${VER}_linux.tar.gz .

RUN tar xzvf bedrock-viz_*_linux.tar.gz

RUN cd /bedrock-viz && \
    patch -p0 < patches/leveldb-1.22.patch && \
    patch -p0 < patches/pugixml-disable-install.patch && \
    mkdir -p build && cd build && \
    cmake .. && \
    make && \
    make install

FROM ubuntu:20.04

COPY --from=builder /usr/local/share/bedrock-viz /usr/local/share/bedrock-viz
COPY --from=builder /usr/local/bin/bedrock-viz /usr/local/bin/

ADD /scripts/ /opt/scripts/

RUN line="*/"$TIMEFRAME" * * * * /opt/scripts/start.sh" && \
    (crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -

RUN mkdir /out && \
    mkdir /world && \
    mkdir /input

ENTRYPOINT ["/opt/scripts/start.sh"]
