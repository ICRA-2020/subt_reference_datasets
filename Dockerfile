# Ubuntu 18.04 with nvidia-docker2 beta opengl support
FROM nvidia/opengl:1.0-glvnd-devel-ubuntu18.04
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Dependencies
RUN apt-get update \
  && apt-get install -y \
  apt-utils \
  build-essential \
  cmake \
  git \
  gnupg \
  lsb-release \
  libusb-dev \
  sudo \
  vim \
  && apt-get clean

# Install ROS Melodic
RUN sudo bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
  && sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN sudo apt-get update \
  && sudo apt-get install -y \
  ros-melodic-ros-base \
  ros-melodic-rviz \
  && sudo apt-get clean \
  && sudo rosdep init \
  && rosdep update

# Other Deps
RUN sudo apt-get update \
  && sudo apt-get install -y \
  apt-utils \
  autoconf \
  libcairo2-dev \
  libceres1 \
  libceres-dev \
  liblua5.3-dev \
  libopencv-core-dev \
  libprotobuf-dev \
  libsuitesparse-dev \
  protobuf-compiler \
  python-catkin-tools \
  python-minimal \
  python-numpy \
  python-rosinstall \
  python-rosinstall-generator \
  python-wstool \
  python3-numpy \
  ros-melodic-camera-info-manager \
  ros-melodic-cv-bridge \
  ros-melodic-eigen-conversions \
  ros-melodic-image-geometry \
  ros-melodic-pcl-ros \
  ros-melodic-random-numbers \
  ros-melodic-tf-conversions \
  && sudo apt-get clean

# Set Working Directory
WORKDIR /home/developer

# Clone/Update Repository
RUN git clone https://git@bitbucket.org/jgrogers/subt_reference_datasets.git \
  && cd subt_reference_datasets \
  && git checkout devel/kimera_reorganization \
  && wstool update -t base_ws/src \
  && wstool update -t kimera_ws/src \
  && ./apply_required_build_patches.sh

# Build Base WS
RUN cd subt_reference_datasets/base_ws \
  && catkin init \
  && catkin config --extend /opt/ros/melodic --merge-devel --cmake-args -DCMAKE_BUILD_TYPE=Release \
  && catkin build

# Build Kimera WS
RUN cd subt_reference_datasets/kimera_ws \
  && catkin init \
  && catkin config --extend ../base_ws/devel --merge-devel --cmake-args -DCMAKE_BUILD_TYPE=Release \
  && catkin build

