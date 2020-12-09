#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
#include <tf/tfMessage.h>
#include <tf/transform_datatypes.h>

std::string base_frame, odom_frame, odom_inv_frame;
ros::Time last_stamp;
tf::TransformBroadcaster *br;

void handleTf(const tf::tfMessage::ConstPtr &data) {
  for(int i=0; i<data->transforms.size(); i++) {
    if (data->transforms[i].header.frame_id == odom_frame && data->transforms[i].child_frame_id == base_frame) {
      tf::Transform temp_tf;
      tf::transformMsgToTF(data->transforms[i].transform, temp_tf);
      br->sendTransform(tf::StampedTransform(
          temp_tf.inverse(),
          data->transforms[i].header.stamp,
          base_frame,
          odom_inv_frame));
    }
  }
}

int main(int argc, char **argv) {
  ros::init(argc, argv, "tf_remap_to_tf_transform_inv");
  ros::NodeHandle nh;
  ros::NodeHandle pnh("~");
 
  pnh.param("odom_frame", odom_frame, std::string("odom"));
  pnh.param("odom_inv_frame", odom_inv_frame, std::string("odom_inv"));
  pnh.param("base_frame", base_frame, std::string("base"));
  
  tf::TransformBroadcaster broadcaster;
  br = &broadcaster;
  
  ros::Subscriber sub_tf = nh.subscribe("/tf_remap", 10, &handleTf);
  ros::spin();
  return -1;
}
