FROM ubuntu:16.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8


RUN apt-get --yes -qq update --allow-insecure-repositories \
 && apt-get --yes -qq upgrade \
 && apt-get --yes -qq install \
                      bzip2 \
                      cmake \
                      cpio \
                      curl \
                      g++ \
                      gcc \
                      gfortran \
                      git \
                      gosu \
                      ssh \
                      openssh-client \ 
                      openssh-server \
                      libblas-dev \
                      liblapack-dev \
                      libopenmpi-dev \
                      openmpi-bin \
                      python3-dev \
                      python3-pip \
                      virtualenv \
                      wget \
                      zlib1g-dev \
                      vim       \
                      htop      \
 && apt-get --yes -qq clean \
 && rm -rf /var/lib/apt/lists/*

 RUN git clone https://github.com/Ilargi12/MPIMatrixMultiplication.git \
    && cd MPIMatrixMultiplication \
    && make \
    && cp mpi_matrix_multiplication /home/


# CMD [ "/bin/bash" ]
# RUN apt-get update --fix-missing \
#      && apt-get install -y openmpi-bin \
#      && apt-get install -y git \
#      && apt-get install -y build-essential \
#      && apt-get install -y make \
#      && apt-get install -y ssh \
#      && apt-get clean \
#      && rm -rf /var/lib/apt/lists/*

CMD mkdir -p /var/run/sshd; /usr/sbin/sshd;
