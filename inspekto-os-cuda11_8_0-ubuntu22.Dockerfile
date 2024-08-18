# Stage 1: Build Python
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 as python-build
ENV DEBIAN_FRONTEND=noninteractive
ARG NVIDIA_DISABLE_REQUIRE=1

# Install dependencies needed to build Python
RUN apt-get update && \
    apt-get -qqqy install \
    build-essential \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    libsqlite3-dev \
    libreadline-dev \
    libbz2-dev \
    libncurses5-dev \
    libgdbm-dev \
    liblzma-dev \
    libncursesw5-dev \
    libdb5.3-dev \
    libexpat1-dev \
    tk-dev \
    wget \
    sudo

# Download, build, and install Python
RUN wget https://www.python.org/ftp/python/3.11.7/Python-3.11.7.tar.xz && \
    tar -xf Python-3.11.7.tar.xz && \
    cd Python-3.11.7 && \
    ./configure --enable-optimizations --enable-shared && \
    make -j$(nproc) && \
    sudo make altinstall && sudo ldconfig && python3.11 --version && \
    cd ../ && rm Python-3.11.7.tar.xz && rm -rf Python-3.11.7

# Stage 2: Final image
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive
ARG NVIDIA_DISABLE_REQUIRE=1

# Copy Python from the build stage
COPY --from=python-build /usr/local /usr/local
COPY --from=python-build /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu

# install cudnn 8.6.0
RUN apt-get update && \
    apt-get install \
    libcudnn8=8.6.0.163-1+cuda11.8 \
    libcudnn8-dev=8.6.0.163-1+cuda11.8

# use bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# install deb apt packages
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
    lsb-core \
    libhdf5-dev \
    python3-gst-1.0 \
    libgeos-dev \
    libgirepository-1.0-1 \
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
    isc-dhcp-server \
    ntfs-3g \
    zip \
    gcc-12 \
    g++-12 \
    google-perftools \
    libaravis-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 10 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 10

RUN apt-get update && \
    apt-get -qqqy install \
    libmkl-dev \
    libtbb2-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*


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

# tools for inspekto_mongo.py backup/restore for ubuntu22.04 mongorestore, mongodump
RUN wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.10.0.deb && \
    sudo apt install -yqqq ./mongodb-database-tools-ubuntu2204-x86_64-100.10.0.deb && \
    rm -f mongodb-database-tools-ubuntu2204-x86_64-100.10.0.deb

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
COPY licenses/python-manual-licenses/* /inspekto_nvm/lib/licenses/

