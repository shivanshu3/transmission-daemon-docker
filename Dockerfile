FROM debian:12

RUN apt update && \
    apt install -y \
        git \
        gosu \
        build-essential \
        cmake \
        libcurl4-openssl-dev \
        libssl-dev \
        python3

RUN mkdir /transmission_build
WORKDIR /transmission_build

ADD https://github.com/transmission/transmission/releases/download/4.0.3/transmission-4.0.3.tar.xz ./
RUN tar xf transmission-4.0.3.tar.xz
WORKDIR /transmission_build/transmission-4.0.3

# Apply this patch to fix broken magnet links:
# https://github.com/transmission/transmission/pull/5460
RUN mkdir ./patches
ADD https://github.com/transmission/transmission/commit/2be3ecfd275bfcd187a42b0ca2cf50420838de53.patch ./patches/
RUN cat ./patches/2be3ecfd275bfcd187a42b0ca2cf50420838de53.patch | patch -p1

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
    make -j 40

VOLUME /config

COPY entrypoint.sh /
CMD ["/entrypoint.sh"]
