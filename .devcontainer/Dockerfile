FROM nvcr.io/nvidia/cuda:13.5.0-cudnn-devel-ubuntu26.04

USER root
RUN apt-get update && apt-get install -y sudo && \
    usermod -aG sudo ubuntu && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu
USER ubuntu

RUN sudo apt-get update && sudo apt-get install -y\
        build-essential\
        cmake\
        curl\
        git\
        htop\
        libegl1\
        libosmesa6\
        libosmesa6-dev\
        libhdf5-dev\
        libhdf5-serial-dev\
        pkg-config \
        python3\
        python3-dev\
        python3-pip\
        python3-venv\
    && sudo apt-get autoremove &&\
    curl -LsSf https://astral.sh/uv/install.sh | sh