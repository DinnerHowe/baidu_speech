cmake_minimum_required(VERSION 2.8.3)
project(simple_voice)

find_package(catkin REQUIRED COMPONENTS
  rospy
)


## Generate messages in the 'msg' folder
# add_message_files(
#   FILES
#   Message1.msg
#   Message2.msg
# )

## Generate services in the 'srv' folder
# add_service_files(
#   FILES
#   Service1.srv
#   Service2.srv
# )

## Generate added messages and services with any dependencies listed here
# generate_messages(
#   DEPENDENCIES
#   std_msgs  # Or other packages containing msgs
# )


catkin_package(
#  INCLUDE_DIRS include
  LIBRARIES simple_voice
  CATKIN_DEPENDS rospy
  DEPENDS system_lib
)

include_directories(
  ${catkin_INCLUDE_DIRS}
)

