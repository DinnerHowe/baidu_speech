#!/usr/bin/env python
# -*- coding: utf-8 -*-

import rospy
from std_msgs.msg import String

def talker():
 pub = rospy.Publisher('speak_string', String, queue_size=1)
 rospy.init_node('fake_speak_string_pubber', anonymous=True)
 rate = rospy.Rate(10) # 10hz
 while not rospy.is_shutdown():
  hello_str = get_text()
  rospy.loginfo(hello_str)
  pub.publish(hello_str)
  rate.sleep()

def get_text():
 return raw_input('请输入想要合成的话语： ')
  
if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass
