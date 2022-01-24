FROM ubuntu:focal as lammps-base

ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/opt/lammps/src:$LD_LIBRARY_PATH

# Update to latest packages and development tools
RUN apt update -y \
    && apt install -y \
        g++ \
        gcc \
        gfortran \
        git \
        libz-dev \
        make \
        mpi-default-bin \
        mpi-default-dev \
        python3-dev \
        python3-pip \
        wget \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

# Download LAMMPS
RUN git clone -b stable https://github.com/lammps/lammps.git /opt/lammps

# Compile LAMMPS
WORKDIR /opt/lammps/src
RUN export LAMMPS_PACKAGES="asphere body class2 colloid compress coreshell dipole granular kspace manybody mc misc molecule opt peri qeq replica rigid shock srd ml-snap reaxff" \
    && for pack in $LAMMPS_PACKAGES; do make "yes-$pack"; done \
    && make mode=shlib mpi LMP_INC="-DLAMMPS_EXCEPTIONS -DLAMMPS_GZIP -DLAMMPS_MEMALIGN=64 -DBUILD_SHARED_LIBS=on" \
    && make install-python


