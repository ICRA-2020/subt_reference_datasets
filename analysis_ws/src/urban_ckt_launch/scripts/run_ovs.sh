#!/usr/bin/env bash

CALIBRATION_FILE=$1
#CALIBRATION_DIR=$(rospack find vision_core)/calibrations/ovs
CALIBRATION_DIR=/vision-core/src/metapackage/calibrations/ovs
LEFT_IMAGE_TOPIC=$2
RIGHT_IMAGE_TOPIC=$3
WORLD_FRAME=$4
BASE_FRAME=$5
CAMERA_FRAME=$6

# Make sure processes in the container can connect to the x server
# Necessary so gazebo can create a context for OpenGL rendering (even headless)
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

docker run \
  -e DISPLAY \
  -e QT_X11_NO_MITSHM=1 \
  --gpus all \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e XAUTHORITY=$XAUTH \
  -v "$XAUTH:$XAUTH" \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:ro" \
  -v "/etc/localtime:/etc/localtime:ro" \
  -v "/dev/input:/dev/input" \
  --network host \
  --privileged \
  --rm vision_core:latest \
  -c ". /vision-core/devel/setup.bash && roslaunch --wait openvslam_ros openvslam_node.launch config_file:=$CALIBRATION_FILE left_image_topic:=$LEFT_IMAGE_TOPIC right_image_topic:=$RIGHT_IMAGE_TOPIC world_frame:=$WORLD_FRAME base_frame:=$BASE_FRAME camera_frame:=$CAMERA_FRAME"
  
