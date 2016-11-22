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
  self.language_lib = ['zh','ct','en']
  self.gender_lib = ['man', 'women']
  self.level = range(0,10)

 def Sentence(self, words):
  self.say.publish(words)

 def engine_setting(self, name = 'baidu')
  rospy.loginfo('currently just support baidu and google')
  rospy.set_param('~engine_name', name)

 #speaker_settings
 def Gender_setting(self, data):
  rospy.loginfo('please input man/women')
  if data in self.gender_lib:
   rospy.set_param('~Gender', data)

 def language_setting(self, data):
  rospy.loginfo('please input zh (Chinese), ct (Cantonese), en （English）')
  if data in self.language_lib:
   rospy.set_param('~LAN', data)

 def speed_setting(self, data):
  rospy.loginfo('speak speed range is 0 ~ 9')
  if data in self.level:
   rospy.set_param('~SPEED', data)
  else:
   rospy.loginfo('currently not support this speak speed level')

 def intonation_setting(self, data):
  rospy.loginfo('intonation range is 0 ~ 9')
  if data in self.level:
   rospy.set_param('~PIT', data)
  else:
   rospy.loginfo('currently not support this intonation level')

 def volume_setting(self, data):
  rospy.loginfo('intonation range is 0 ~ 9')
  if data in self.level:
   rospy.set_param('~VOL', data)
  else:
   rospy.loginfo('currently not support this intonation level')

 def format_setting(self, data):
  rospy.set_param('~FORMAT', data)

 def response_sensitivity(self, data):
  rospy.set_param('~ResponseSensitivity', data)

 def workspace_setting(self, data):
  rospy.set_param('~WorkSpaces', data)

 #engine setting
 def CTP_setting(self, data):
  if data == 1:
   rospy.set_param('~CTP', data)
  else:
   rospy.loginfo('currently not support this customer terminal type')

 def USER_ID_setting(self, data):
  rospy.set_param('~USER_ID', data)

 def Api_Key_setting(self, data):
  rospy.set_param('~Api_Key', data)

 def Secrect_Key_setting(self, data):
  rospy.set_param('~Secrect_Key', data)

 def Grant_type_setting(self, data):
  rospy.set_param('~Grant_type', data)

 def Token_url_setting(self, data):
  rospy.set_param('~Token_url', data)

 def Speeker_url_setting(self, data):
  rospy.set_param('~Speeker_url', data)

class STT_():
 def __init__(self):
  self.define()

 def define(self):
  self.samples_number_range = range(1500, 2501)
  self.sample_rate_range = range(7000, 9001)

 def samples_number_setting(self, data):
  rospy.loginfo('please input samples number')
  if data in self.samples_number_range:
   rospy.set_param('~REG_NUM_SAMPLES', data)
  else:
   rospy.loginfo('data out of range')

 def sample_rate_setting(self, data):
  rospy.loginfo('please input sampling rate')
  if data in self.sample_rate_range:
   rospy.set_param('~REG_SAMPLING_RATE', data)
  else:
   rospy.loginfo('data out of range')

 def upper_level_setting(self, data):
  rospy.loginfo('please input upper level of sampling')
  rospy.set_param('~REG_UPPER_LEVEL', data)

 def lower_level_setting(self, data):
  rospy.loginfo('please input lower level of sampling')
  rospy.set_param('~REG_LOWER_LEVEL', data)

 def count_number_setting(self, data):
  rospy.loginfo('please input how much number of data higher than lower level counted before recording')
  rospy.set_param('~REG_COUNT_NUM:', data)

 def save_length_setting(self, data):
  rospy.loginfo('please input recording uni length of voice data')
  rospy.set_param('~REG_SAVE_LENGTH:', data)

 def time_out_setting(self, data):
  rospy.loginfo('please input max recording time once starting speaking')
  rospy.set_param('~REG_TIME_OUT', data)

 def no_words_setting(self, data):
  rospy.loginfo('please input the period of stop recording if there is no words coming')
  rospy.set_param('~REG_NO_WORDS', data)

 def Api_Key_setting(self, data):
  rospy.loginfo('please input a Baidu API KEY')
  rospy.set_param('~REG_Api_Key', data)

 def Secrect_Key_setting(self, data):
  rospy.loginfo('please input a Baidu Secrect Key')
  rospy.set_param('~REG_secrect_Key', data)

 def Grant_type_setting(self, data):
  rospy.loginfo('please input Baidu Grant type')
  rospy.set_param('~REG_Grant_type')

 def Token_url_setting(self, data):
  rospy.loginfo('please input Baidu Token url')
  rospy.set_param('~REG_Token_url', data)

 def Reg_url_setting(self, data):
  rospy.loginfo('please input Baidu Reg url')
  rospy.set_param('~REG_Reg_url', data)

 def USER_ID_setting(self, data):
  rospy.loginfo('please input Baidu USER_ID')
  rospy.set_param('~Reg_USER_ID', data)

 def format_setting(self, data):
  rospy.loginfo('please input VOICE DATA SAVING FORMAT')
  rospy.set_param('~REG_FORMAT', data)

 def language_setting(self, data):
  rospy.loginfo('~please input regnising langurage')
  if data in ['man', 'women']:
   rospy.set_param('~REG_LAN', data)
  else:
   rospy.loginfo('data out of range')

 def nchannel_setting(self, data):
  rospy.loginfo('please input what channel will voice data record')
  rospy.set_param('~REG_nchannel', data)