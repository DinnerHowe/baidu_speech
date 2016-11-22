#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Copyright (c) 2016 Xu Zhihao (Howe).  All rights reserved.
This program is free software; you can redistribute it and/or modify
This programm is tested on kuboki base turtlebot.
This is API for setting param
"""

import rospy

class TTS_set():
 def __init__(self):
  self.define(self)
  
 def define(self):
  self.say=rospy.Publisher('speak_string', String, queue_size=1)
 
 def Sentence(self, words):
  self.say.publish(words)

 def engine(self, name = 'baidu')
  rospy.loginfo('currently just support baidu and google')
  if not rospy.has_param('~engine_name'):
   rospy.set_param('~engine_name', name)

 def language(self, data):
  if not rospy.has_param('LAN'):
   rospy.set_param('~LAN', data)

 #speaker_settings
 def Gender(self, data):
  if not rospy.has_param('~Gender'):
   rospy.set_param('~Gender', data)

 def id(self, data):
  if not rospy.has_param('~USER_ID')

 #engine setting
 def
