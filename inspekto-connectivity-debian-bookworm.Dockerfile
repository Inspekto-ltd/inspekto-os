FROM debian:bookworm-slim-ddce62e As python-build

# Install Bash and core utilities
RUN apt-get update && \
    apt-get install -y \
            bash \
            coreutils \
            util-linux \
            libzmq5 \
            isc-dhcp-server \
            net-tools \
            iproute2 \
            && rm -rf /var/lib/apt/lists/*

# Environment variables
ENV ENVS_PATH=/inspekto_nvm/lib/env
ENV STORAGE_LOGS_PATH=inspekto_nvm/logs
ENV PROFINET_DRIVER_PATH=/root/goal_linux_x64.bin
ENV ETHIP_DRIVER_PATH=/root/S70_enip

# Ensure directories are created
RUN mkdir -p /inspekto_nvm/logs
RUN mkdir -p /inspekto_nvm/lib/env

# Add the bin and script to for profinet
# requires CONNECTIVITY_INTERFACE env variable
COPY ./connectivity_files/goal_linux_x64_V5.1.bin /root/goal_linux_x64.bin
COPY ./connectivity_files/start_profinet.sh /root/start_profinet.sh
# Add the bin and script to for ethip
COPY ./connectivity_files/S70_enip /root/S70_enip
COPY ./connectivity_files/start_ethip.sh /root/start_ethip.sh
# Add conf for digitalio isc-dhcp-server
COPY ./connectivity_files/start_digitalio.sh /root/start_digitalio.sh

# Make sure scripts are executable
RUN chmod +x \
    /root/goal_linux_x64.bin \
    /root/start_profinet.sh \
    /root/S70_enip \
    /root/start_ethip.sh \
    /root/start_digitalio.sh

