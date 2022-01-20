FROM ubuntu:focal as lammps-base

ENV DEBIAN_FRONTEND=noninteractive

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
        wget \
    && rm -rf /var/lib/apt/lists/*

# Download LAMMPS
#RUN git clone -b stable https://github.com/lammps/lammps.git /opt/lammps
ADD lammps-clone /opt/lammps

# Compile LAMMPS
#ENV LAMMPS_PACKAGES="asphere body class2 colloid compress coreshell dipole granular kspace manybody mc misc molecule opt peri qeq replica rigid shock snap srd reax"

#RUN export LAMMPS_PACKAGES="asphere body class2 colloid compress coreshell dipole granular kspace manybody mc misc molecule opt peri qeq replica rigid shock snap srd reax" \
WORKDIR /opt/lammps/src
RUN export LAMMPS_PACKAGES="asphere body class2 colloid compress coreshell dipole granular kspace manybody mc misc molecule opt peri qeq replica rigid shock srd ml-snap reaxff" \
    && for pack in $LAMMPS_PACKAGES; do make "yes-$pack"; done

RUN make mode=shlib mpi LMP_INC="-DLAMMPS_EXCEPTIONS -DLAMMPS_GZIP -DLAMMPS_MEMALIGN=64 -DBUILD_SHARED_LIBS=on"
