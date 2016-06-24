FROM ubuntu:14.04

MAINTAINER MOZGIII <mike-n@narod.ru>

# Install distribution specific dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    "^libxcb.*" \
    bison \
    build-essential \
    ca-certificates \
    cmake \
    flex \
    git \
    gperf \
    libasound2-dev \
    libcap-dev \
    libegl1-mesa-dev \
    libfontconfig1-dev \
    libglu1-mesa-dev \
    libicu-dev \
    libnss3-dev \
    libpci-dev \
    libpulse-dev \
    libssl-dev \
    libudev-dev \
    libx11-xcb-dev \
    libxcomposite-dev \
    libxcursor-dev \
    libxdamage-dev \
    libxi-dev \
    libxrandr-dev \
    libxrender-dev \
    libxslt-dev \
    libxss-dev \
    libxtst-dev \
    locales \
    make \
    perl \
    python \
    ruby \
    wget \
 && apt-get build-dep -y qt5-default \
 && rm -rf /var/lib/apt/lists/*

# Add tini as pid 1 process
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0527A9B7 \
 && gpg --verify /tini.asc \
 && chmod +x /tini
ENTRYPOINT ["/tini", "--"]
