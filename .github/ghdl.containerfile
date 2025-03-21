# Author:
#   Unai Sainz-Estebanez
# Email:
#  <unai.sainze@ehu.eus>
#
# Licensed under the GNU General Public License v3.0;
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.gnu.org/licenses/gpl-3.0.html

# GHDL container

MAINTAINER <unike267@gmail.com>

FROM ubuntu:latest AS base

ARG GNAT_VER="13"
ARG LLVM_VER="18"

# Install dependencies
RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    ca-certificates \
    clang-$LLVM_VER \
    gcc \
    gnat-$GNAT_VER \
    llvm-$LLVM_VER-dev \
    make \
    zlib1g-dev \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && update-ca-certificates \
 && rm -rf /var/lib/apt/lists/* 

FROM base AS build

ARG LLVM_VER="18"

# Install ghdl
RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    git \
 && git clone https://github.com/ghdl/ghdl \
 && cd ghdl \
 && mkdir build-llvm \
 && cd build-llvm \
 && CXX=clang++-$LLVM_VER ../configure --with-llvm-config=llvm-config-$LLVM_VER --default-pic --disable-werror \
 && make -j$(nproc) \
 && make DESTDIR=/opt/ghdl/ install \
 && cd ../.. \
 && rm -rf ghdl 

# Temporary scratch image for “transporting” the compiled GHDL binaries
FROM scratch AS tmp_ghdl
COPY --from=build /opt/ghdl/ /ghdl/

# Final ghdl dependent target
FROM base AS ghdl
COPY --from=tmp_ghdl /ghdl/usr/local /usr/local/

RUN ghdl --version
