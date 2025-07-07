FROM debian:12

RUN apt update && \
    apt install -y \
        build-essential \
        cmake \
        curl \
        git \
        gosu \
        libcurl4-openssl-dev \
        libssl-dev \
        netcat-openbsd \
        procps \
        python3

RUN mkdir /transmission_build
WORKDIR /transmission_build

ADD https://github.com/transmission/transmission/releases/download/4.0.4/transmission-4.0.4.tar.xz ./
RUN tar xf transmission-4.0.4.tar.xz
WORKDIR /transmission_build/transmission-4.0.4

RUN mkdir build && \
    cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DENABLE_DAEMON=ON \
        -DENABLE_CLI=OFF \
        -DENABLE_GTK=OFF \
        -DENABLE_MAC=OFF \
        -DENABLE_QT=OFF \
        -DENABLE_UTILS=OFF \
        .. && \
    make -j $(nproc)

VOLUME /config

COPY entrypoint.sh /
CMD ["/entrypoint.sh"]
