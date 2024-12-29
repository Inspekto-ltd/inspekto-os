ARG INSPEKTO_OS_BOOKWORM_IMAGE_TAG

FROM $INSPEKTO_OS_BOOKWORM_IMAGE_TAG

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb && \
    sudo dpkg -i cuda-keyring_1.1-1_all.deb && \
    sudo apt-get update && \
    sudo apt-get -y install cuda-toolkit-12-5

RUN wget https://developer.download.nvidia.com/compute/cudnn/9.3.0/local_installers/cudnn-local-repo-debian12-9.3.0_1.0-1_amd64.deb && \
    sudo rm -f /etc/apt/sources.list.d/cuda*.list && \
    sudo dpkg -P cudnn-local-repo-debian12-9.3.0 && \
    sudo dpkg -i cudnn-local-repo-debian12-9.3.0_1.0-1_amd64.deb && \
    sudo cp /var/cudnn-local-repo-debian12-9.3.0/cudnn-local-4DAB5DC2-keyring.gpg /usr/share/keyrings/ && \
    sudo apt update && \
    sudo apt install -y \
        cudnn=9.3.0-1 \
        cudnn9-cuda-12=9.3.0.75-1 \
        libcudnn9-cuda-12=9.3.0.75-1 \
        libcudnn9-dev-cuda-12=9.3.0.75-1 && \
    apt list --installed | grep cudnn && \
    cat /usr/include/cudnn_version.h | grep CUDNN_MAJOR -A 2

