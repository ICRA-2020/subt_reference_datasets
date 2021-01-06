#/bin/bash
# Bags are run at 1/4th speed due to compression
. ../../algorithm_ws/devel/setup.bash

# SR:
  # Route 1:
    # Cartographer
    roslaunch tunnel_ckt_launch remap.launch bag:=sr_B_route1.bag cartographer:=true noodom:=true course:=sr config:=B rate:=0.25
    
    # ORBSLAM
    roslaunch tunnel_ckt_launch remap.launch bag:=sr_B_route1.bag orbslam:=true course:=sr config:=B rate:=0.25
    
    # Odom
    roslaunch tunnel_ckt_launch remap.launch bag:=sr_B_route1.bag odom_only:=true course:=sr config:=B rate:=0.25
