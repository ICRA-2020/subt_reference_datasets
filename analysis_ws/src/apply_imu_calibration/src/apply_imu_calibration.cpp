#include <ros/ros.h>
#include <sensor_msgs/Imu.h>
#include <tf/tf.h>
#include <tf/transform_datatypes.h>

class ApplyImuCalibration{
 protected:
    ros::Publisher imu_repub;
    ros::Subscriber sub;
    double offset_r, offset_p, offset_y;
    std::string output_frame_id;
    ros::NodeHandle nh;
    ros::NodeHandle private_nh;
 public:
    ApplyImuCalibration();
    void init();
    void handler(const sensor_msgs::Imu::ConstPtr& msg);
};

ApplyImuCalibration::
ApplyImuCalibration():
nh(), private_nh("~") {
  private_nh.param("offset_r", offset_r, 0.0);
  private_nh.param("offset_p", offset_p, 0.0);
  private_nh.param("offset_y", offset_y, 0.0);
  private_nh.param("output_frame_id", output_frame_id, std::string("imu_reframe"));
}

void ApplyImuCalibration::
init() {

  imu_repub = nh.advertise<sensor_msgs::Imu>("imu_repub", 10);
  sub = nh.subscribe<sensor_msgs::Imu>("imu/data", 10, boost::bind(&ApplyImuCalibration::handler, this, _1));
}

void ApplyImuCalibration::
handler(const sensor_msgs::Imu::ConstPtr& msg) {
  sensor_msgs::Imu out_msg = *msg;
  out_msg.header.frame_id = output_frame_id;
  tf::Quaternion quat;
  tf::quaternionMsgToTF(msg->orientation, quat);
  tf::Quaternion calib_quat;
  calib_quat.setRPY(offset_r, offset_p, offset_y);
  quat = calib_quat * quat;
  tf::quaternionTFToMsg(quat, out_msg.orientation);
  imu_repub.publish(out_msg);
}

int main(int argc, char** argv) {
  ros::init(argc, argv, "apply_imu_calibration");
  ApplyImuCalibration calibrator;
  calibrator.init();
  ros::spin();
}
