# ==================================================================
# module list
# ------------------------------------------------------------------
# Ubuntu           20.04
# ==================================================================

FROM ubuntu:20.04
LABEL maintainer="yym064@naver.com"

ENV APT_INSTALL="apt-get install -y --no-install-recommends"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        git wget vim curl

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ==================================================================
# Set Environments
# ------------------------------------------------------------------
ENV LC_ALL=C.UTF-8

# ==================================================================
# Git Clone
# ------------------------------------------------------------------

RUN apt-get -y update 
RUN apt-get install -y \
        # Base tools
        cmake \
        build-essential \
        git \
        unzip \
        pkg-config \
        python-dev \
        # OpenCV dependencies
        python-numpy \
        gtk+2.0 \
        # Pangolin dependencies
        libgl1-mesa-dev \
        libglew-dev \
        libpython2.7-dev \
        libeigen3-dev \
        apt-transport-https \
        ca-certificates\
        software-properties-common

WORKDIR /home
RUN git config --global http.sslverify false
RUN git clone https://github.com/JakobEngel/dso.git

# ==================================================================
# Required Dependencies
# ------------------------------------------------------------------

RUN apt-get -y install libsuitesparse-dev libeigen3-dev libboost-all-dev
RUN apt-get -y install libglew-dev freeglut3-dev libglu1-mesa-dev mesa-common-dev

# ==================================================================
# install Oencv
# ------------------------------------------------------------------
# Build OpenCV (3.0 or higher should be fine)
WORKDIR /home
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.0.zip
RUN unzip opencv.zip
RUN cd opencv-3.4.0 && mkdir build
WORKDIR /home/opencv-3.4.0/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \ -D CMAKE_INSTALL_PREFIX=/usr/local \ -D WITH_TBB=OFF \ -D WITH_GTK_2_x=ON \-D WITH_IPP=OFF \ -D WITH_1394=OFF \ -D BUILD_WITH_DEBUG_INFO=OFF \ -D BUILD_DOCS=OFF \ -D BUILD_EXAMPLES=OFF \ -D BUILD_TESTS=OFF \ -D BUILD_PERF_TESTS=OFF \ -D WITH_QT=ON \ -D WITH_OPENGL=ON \ -D WITH_V4L=ON \ -D WITH_FFMPEG=ON \ -D WITH_XINE=ON \ -D WITH_NVCUVID=OFF \ -D BUILD_NEW_PYTHON_SUPPORT=ON \..
RUN make -j $(nproc)
RUN make install
# ==================================================================
# install libzip-1.1.1
# ------------------------------------------------------------------

WORKDIR /home/dso/thirdparty
RUN apt-get -y install zlib1g-dev
RUN tar -zxvf libzip-1.1.1.tar.gz
WORKDIR /home/dso/thirdparty/libzip-1.1.1
RUN ./configure
RUN make
RUN make install

# ==================================================================
# install Pangolin
# ------------------------------------------------------------------

WORKDIR /home/dso/thirdparty
RUN git clone https://github.com/stevenlovegrove/Pangolin && \
    cd Pangolin && git checkout v0.6 && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-std=c++11 .. && \
    make -j$nproc && make install

# ==================================================================
# build dso
# ------------------------------------------------------------------

WORKDIR /home/dso
RUN mkdir build && cd build && cmake .. && make -j $(nproc)

