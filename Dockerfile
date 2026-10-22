# Image for building Stratux
#
FROM debian:bookworm

# file and nano are nice to have
RUN apt-get update \
  && apt-get -y install file \
  && apt-get -y install nano \
  && apt-get -y install make \
  && apt-get -y install git \
  && apt-get -y install gcc \
  && apt-get -y install ncurses-dev \
  && apt-get -y install wget \
  && apt-get -y install libusb-1.0-0-dev \
  && apt-get -y install build-essential debhelper cmake pkg-config

RUN set -eux; \
    wget -qO /tmp/go-version https://go.dev/VERSION?m=text; \
    read -r GO_VERSION < /tmp/go-version; \
    GO_ARCH="$(dpkg --print-architecture)"; \
    case "$GO_ARCH" in amd64|arm64) ;; *) echo "Unsupported Go architecture: $GO_ARCH" >&2; exit 1 ;; esac; \
    wget -q "https://go.dev/dl/${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -O /tmp/go.tar.gz; \
    tar -C /usr/local -xzf /tmp/go.tar.gz; \
    rm /tmp/go-version /tmp/go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

RUN cd /tmp \
    && git clone https://github.com/osmocom/rtl-sdr \
    && cd rtl-sdr \
    && dpkg-buildpackage -b --no-sign \
    && cd /tmp \
    && dpkg -i librtlsdr0_*.deb \
    && dpkg -i librtlsdr-dev_*.deb \
    && dpkg -i rtl-sdr_*.deb \
    && rm -rf rtl-sdr \
    && rm -f librtlsdr0_*.deb librtlsdr-dev_*.deb rtl-sdr_*.deb

# specific to debian, ubuntu images come with user 'ubuntu' that is uid 1000
ENV USERNAME="stratux"
ENV USER_HOME=/home/$USERNAME

RUN useradd -m -d $USER_HOME -s /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
