#/bin/bash
# Bags are run at 1/5 speed due to compression
. ../../algorithm_ws/devel/setup.bash

# UGV A Level 1
  # Cartographer Odom:
  roslaunch urban_ckt_launch remap.launch bag:=a_lvl_1.bag cartographer:=true noodom:=true odom_mode:=odom odom_config_1:=true course:=alpha config:=2 rviz:=false interval:=0.2 initialize_flat:=true multisense:=false rate:=0.2
  # Cartographer No Odom:
  roslaunch urban_ckt_launch remap.launch bag:=a_lvl_1.bag cartographer:=true noodom:=true odom_mode:=imu odom_config_1:=true course:=alpha config:=2 rviz:=false initialize_flat:=true multisense:=false rate:=0.2
  # LeGO LOAM
  roslaunch urban_ckt_launch remap.launch bag:=a_lvl_1.bag bor_legoloam:=true course:=alpha config:=2 rviz:=false initialize_flat:=true multisense:=false rate:=0.2
  # Odom
  roslaunch urban_ckt_launch remap.launch bag:=a_lvl_1.bag odom_only:=true course:=alpha config:=2 rviz:=false initialize_flat:=true rate:=0.2
    
# UAV A Level 1
  # ORBSLAM2
  roslaunch urban_ckt_launch uav.launch bag:=a_lvl_1_uav.bag orbslam:=true course:=alpha config:=2 rviz:=false rate:=0.2
  # MSCKF
  roslaunch urban_ckt_launch uav.launch bag:=a_lvl_1_uav.bag msckf:=true course:=alpha config:=2 rviz:=false rate:=0.2
  # Kimera
  . ../../kimera_ws/devel/setup.bash
  roslaunch urban_ckt_launch uav.launch bag:=a_lvl_1_uav.bag kimera:=true course:=alpha config:=2 rviz:=false rate:=0.2

