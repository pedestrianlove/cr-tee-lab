FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/NTHU-SCOPELAB/cr-tee-lab"

RUN mkdir -p /workspace/cli

# Install base image
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y && apt upgrade -y && apt install -y adb acpica-tools autoconf automake bc bison build-essential \
            ccache cpio cscope curl device-tree-compiler e2tools expect fastboot flex \
            ftp-upload gdisk git libattr1-dev libcap-ng-dev libfdt-dev libftdi-dev \
            libglib2.0-dev libgmp3-dev libhidapi-dev libmpc-dev libncurses5-dev libpixman-1-dev \
            libslirp-dev libssl-dev libtool libusb-1.0-0-dev make mtools netcat ninja-build \
            python3-cryptography python3-pip python3-pyelftools python3-serial python3-tomli \
            python-is-python3 rsync swig unzip uuid-dev wget xdg-utils xsltproc xterm xz-utils \
            zlib1g-dev zlib1g libgnutls28-dev

RUN apt install -y tmux

# Prevent container from exiting early.
CMD ["sleep", "infinity"]
