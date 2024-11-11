FROM kapdap/gosu AS gosu
FROM python:3.12-slim
LABEL maintainer="kapdap@pm.me"

ARG BINWALK_VERSION="v2.4.3"

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_ROOT_USER_ACTION=ignore

ENV U_ID=1000 \
    G_ID=1000

COPY --from=gosu /bin/gosu* /usr/bin/
COPY base/ /

RUN chmod +x /docker-entrypoint.sh \
    && chmod +x /docker-entrypoint.d/*

WORKDIR /build

RUN apt-get -yq update \
    && apt-get -yq dist-upgrade --no-install-recommends -o Dpkg::Options::="--force-confold" \
    && apt-get -yq install \
        arj \
        build-essential \
        bzip2 \
        cabextract \
        cpio \
        cramfsswap \
        default-jdk \
        git \
        gzip \
        lhasa \
        liblzma-dev \
        liblzo2-dev \
        locales \
        lzop \
        mtd-utils \
        p7zip \
        p7zip-full \
        python3-capstone \
        python3-distutils \
        python3-gnupg \
        python3-matplotlib \
        python3-poetry \
        python3-pycryptodome \
        python3-setuptools \
        qtbase5-dev \
        sleuthkit \
        sudo \
        squashfs-tools \
        srecord \
        tar \
        wget \
        zlib1g-dev \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install pipx \
    && pipx ensurepath -q --global \
    && pipx install -q --global jefferson \
    && pipx install -q --global ubi_reader \
    && git config --global advice.detachedHead false \
    && git clone --quiet --depth 1 --branch "master" https://github.com/devttys0/sasquatch \
    && (cd sasquatch \
        && wget https://github.com/devttys0/sasquatch/pull/47.patch \
        && patch -p1 < 47.patch \
        && ./build.sh) \
    && git clone --quiet --depth 1 --branch "master" https://github.com/devttys0/yaffshiv \
    && (cd yaffshiv && pipx install -q --global .) \
    && git clone --quiet --depth 1 --branch "master" https://github.com/npitre/cramfs-tools \
    && (cd cramfs-tools && TIME=`date +%s` && make && install cramfsck /usr/local/bin) \
    && git clone --quiet --depth 1 --branch "${BINWALK_VERSION}" https://github.com/OSPG/binwalk \
    && (cd binwalk && pipx install -q --global .) \
    && apt-get -yq purge *-dev git build-essential gcc g++ \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && rm -rf -- \
        /build \
        /var/lib/apt/lists/* \
        /root/.cache/pip

WORKDIR /app

ENTRYPOINT [ "/docker-entrypoint.sh", "binwalk" ]