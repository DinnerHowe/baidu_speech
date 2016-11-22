#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Copyright (c) 2016 Xu Zhihao (Howe).  All rights reserved.
This program is free software; you can redistribute it and/or modify
This programm is tested on kuboki base turtlebot.
This is API for setting param
"""

import rospy

class TTS_():
 def __init__(self):
  self.define(self)
  
 def define(self):
  self.say=rospy.Publisher('speak_string', String, queue_size=1)
 
 def Sentence(self, words):
  self.say.publish(words)

 def engine_setting(self, name = 'baidu')
  rospy.loginfo('currently just support baidu and google')
  rospy.set_param('~engine_name', name)

 #speaker_settings
 def Gender_setting(self, data):
  rospy.set_param('~Gender', data)

 def language_setting(self, data):
  rospy.set_param('~LAN', data)

 def speed_setting(self, data):
  rospy.set_param('~SPEED', data)

 def intonation_setting(self, data):
  rospy.set_param('~PIT', data)

 def volume_setting(self, data):
  rospy.set_param('~VOL', data)

 def format_setting(self, data):
  rospy.set_param('~FORMAT', data)

 def response_sensitivity(self, data):
  rospy.set_param('~ResponseSensitivity', data)

 def workspace_setting(self, data):
  rospy.set_param('~WorkSpaces', data)

 #engine setting
 def CTP_setting(self, data):
  rospy.set_param('~CTP', data)

 def user_id_setting(self, data):
  rospy.set_param('~USER_ID', data)

 def key_setting(self, data):
  rospy.set_param('~Api_Key', data)

 def secrect_key_setting(self, data):
  rospy.set_param('~Secrect_Key', data)

 def grant_type_setting(self, data):
  rospy.set_param('~Grant_type', data)

 def Token_url_setting(self, data):
  rospy.set_param('~Token_url', data)

 def Speeker_url_setting(self, data):
  rospy.set_param('~Speeker_url', data)

class STT_():
 def