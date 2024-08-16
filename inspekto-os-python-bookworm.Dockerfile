FROM python:3.11.7-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive
ARG NVIDIA_DISABLE_REQUIRE=1

# use bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# install apt prerequisites
RUN apt-get update && \
    apt-get -qqqy install \
    wget \
    sudo \
    git \
    curl \
    unzip \
    net-tools \
    network-manager \
    jq \
    vim \
    xclip \
    udev \
    tzdata \
    cmake \
    apt-utils \
    lsb-release \
    lsb-base \
    libhdf5-dev \
    python3-gst-1.0 \
    libgeos-dev \
    libgirepository1.0-dev \
    libcairo2-dev \
    pkg-config \
    gir1.2-gtk-3.0 \
    libgstreamer1.0-0 \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    libxml2 \
    libzip-dev \
    libglib2.0-0 \
    libgirepository-1.0-1 \
    libudev1 \
    libusb-1.0-0 \
    libuuid1 \
    libpcap0.8 \
    qtgstreamer-plugins-qt5 \
    python3-pyqt5 \
    python3-gi \
    libcap-dev \
    libzmq3-dev \
    ethtool \
    ntfs-3g \
    zip \
    gcc-12 \
    g++-12 \
    google-perftools \
    libaravis-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://deb.debian.org/debian bookworm non-free" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get -qqqy install \
    libmkl-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/apt/sources.list

RUN apt update && git clone --branch v-tiscamera-1.1.1 --depth 1 https://github.com/TheImagingSource/tiscamera.git && \
    cd tiscamera && \
    ./scripts/dependency-manager install --yes && \
    mkdir build && \
    cd build && \
    cmake \
        -DBUILD_ARAVIS=ON \
        -DBUILD_DOCUMENTATION=OFF \
        -DBUILD_TOOLS=ON \
        -DBUILD_GST_1_0=ON \
        -DTCAM_INTERNAL_ARAVIS=ON \
        -DTCAM_BUILD_WITH_GUI=OFF .. && \
    make && \
    sudo make install && \
    cd ../../ && rm -rf tiscamera

# one python to rule them all
RUN rm -rf /usr/bin/python3 && ln -s /usr/local/bin/python3.11 /usr/bin/python3 && \
    rm -rf /usr/bin/python && ln -s /usr/local/bin/python3.11 /usr/bin/python

RUN python3 -m pip install --no-cache-dir --upgrade pip

# create necessary directories
RUN mkdir -p /root/.fixi/cfg && \
    mkdir -p /inspekto_nvm/lib/env && \
    mkdir -p /inspekto_nvm/cfg && \
    mkdir -p /inspekto_nvm/sam_vit && \
    mkdir -p /host_cfg && \
    touch /host_cfg/cfg.ini

# copy licenses
COPY licenses/deb-licenses/* /inspekto_nvm/lib/licenses/
COPY licenses/other-licenses/* /inspekto_nvm/lib/licenses/
COPY licenses/python-licenses/* /inspekto_nvm/lib/licenses/

# tools for inspekto_mongo.py backup/restore for ubuntu22.04 mongorestore, mongodump
RUN wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-debian12-x86_64-100.10.0.deb && \
    sudo apt install -yqqq ./mongodb-database-tools-debian12-x86_64-100.10.0.deb && \
    rm -f mongodb-database-tools-debian12-x86_64-100.10.0.deb

# Copy requirements files
COPY init_files/requirements-frozen.txt /
COPY init_files/requirements-pytorch-frozen.txt /
COPY init_files/requirements-post-pytorch-frozen.txt /
COPY init_files/requirements-pydensecrf-frozen.txt /

# Install Python packages
RUN export PIP_DEFAULT_TIMEOUT=100 && python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir --ignore-installed -r requirements-frozen.txt && \
    python3 -m pip install --no-cache-dir -r requirements-pytorch-frozen.txt && \
    python3 -m pip install --no-cache-dir -r requirements-post-pytorch-frozen.txt && \
    python3 -m pip install --no-cache-dir --no-build-isolation -r requirements-pydensecrf-frozen.txt

# Reinstall pymongo
RUN python3 -m pip install --no-cache-dir --upgrade pymongo==4.3.3 && \
    python3 -m pip install --no-cache-dir --upgrade pymongo==4.4.0
