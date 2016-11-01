#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Copyright (c) 2016 Xu Zhihao (Howe).  All rights reserved.
This program is free software; you can redistribute it and/or modify
This programm is tested on kuboki base turtlebot."""

import rospy
from std_msgs.msg import String

class recoder_main():
 def __init__(self):
  self.define()
  rospy.Subscriber(self.topic , String , self.talker)
  rospy.spin()
   
 def define(self):
  self.say=rospy.Publisher('speak_string', String, queue_size=1)
  if not rospy.has_param('~words'):
   rospy.set_param('~words','请让一下，谢谢')
   
  if not rospy.has_param('~SpeakerSubTopic'):
   rospy.set_param('~SpeakerSubTopic', 'stop_flag')
   
  self.words=rospy.get_param('~words')
  self.topic=rospy.get_param('~SpeakerSubTopic')
  
 def talker(self,data):
  if data.data=='stop':
   self.say.publish(self.words)
  else:
   pass
   
if __name__=="__main__":
 rospy.init_node('warning2speaker')
 rospy.loginfo("initialization system")
 recoder_main()
 rospy.loginfo("process done and quit")
