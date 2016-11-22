#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Copyright (c) 2016 Xu Zhihao (Howe).  All rights reserved.
This program is free software; you can redistribute it and/or modify
This programm is tested on kuboki base turtlebot."""

from pyaudio import PyAudio, paInt16
import json
import base64
import os
import sys
import requests
import wave
import rospy
import numpy as np 
import array
import chunk
from std_msgs.msg import String

class recoder():

 def __init__(self):
  if_continue=''
  while not rospy.is_shutdown() and if_continue == '':
  
   self.define()

   self.recode()

   words = self.reg()

   reg = rospy.Publisher('Rog_result', String, queue_size=1)

   reg.publish(words)

   #self.savewav("testing")#testing
   
   if_continue = raw_input('pls input ＥＮＴＥＲ to continue')

 def reg(self):
 
  #get token
  requestData = {       "grant_type":           self.Grant_type, 
                        "client_id":            self.Api_Key, 
                        "client_secret":        self.Secrect_Key}
  
  result = requests.post(url = self.Token_url, data = requestData)
  
  token_data = json.loads(result.text)
  
  #self.Print_Response(token_data)
  
  if 'access_token' in token_data:  
   token = token_data['access_token']  
   rospy.loginfo('token success\n')
  else:
   rospy.loginfo('token failed\n')
   
  
  #self.print_data_len(self.Voice_String)
  
  str_voice=self.conventor(self.Voice_String)
  
  speech = base64.b64encode(str_voice)

  size = len(str_voice)

  
  RegData = {   "format":       self.FORMAT,
                "rate":         self.SAMPLING_RATE,
                "channel":      self.nchannel,
                "cuid":         self.USER_ID,
                "token":        token,
                "len":          size,
                "speech":       speech,
                "lan":          self.LAN}
                
  HTTP_HEADER=          {  'Content-Type':      'audio/%s;rate=%s'%(self.FORMAT,self.SAMPLING_RATE),
                           'Content-length':    len(json.dumps(RegData))}

  r = requests.post(url = self.Reg_url, data = json.dumps(RegData, sort_keys=True), headers=HTTP_HEADER)
  

  rospy.loginfo( 'response')
  self.Print_Response(r.headers)
  result = json.loads(r.text)
  self.Print_Response(result)
  rospy.loginfo( 'result: %s \n'%result['err_msg'])#,type(result)
  rospy.loginfo( 'response\n')
  
  if result[u'err_msg']=='success.':
   word = result['result'][0].encode('utf-8')
   if word!='':
    if word[len(word)-3:len(word)]=='，':
     rospy.loginfo('cog. result:　%s \n'%word[0:len(word)-3])
     return word[0:len(word)-3]
    else:
     rospy.loginfo(word)
     return word
   else:
    rospy.loginfo("音频文件不存在或格式错误\n")
    return '音频文件不存在或格式错误'
  else:
   rospy.loginfo(self.error_reason[result[u'err_no']])
   return  self.error_reason[result[u'err_no']]
   
  rospy.sleep(2)
   
   
 def define(self):
  self.error_reason={3300:      '输入参数不正确',
                     3301:      '识别错误',
                     3302:      '验证失败',
                     3303:      '语音服务器后端问题',
                     3304:      '请求 GPS 过大，超过限额',
                     3305:      '产品线当前日请求数超过限额'}
 
  if rospy.has_param('~REG_NUM_SAMPLES'):
   pass
  else:
   rospy.set_param('~REG_NUM_SAMPLES', 2000)
  
  if rospy.has_param('~REG_SAMPLING_RATE'):
   pass
  else:
   rospy.set_param('~REG_SAMPLING_RATE', 8000)
  
  if rospy.has_param('~REG_UPPER_LEVEL'):
   pass
  else:
   rospy.set_param('~REG_UPPER_LEVEL', 5000)

  if rospy.has_param('~REG_LOWER_LEVEL'):
   pass
  else:
   rospy.set_param('~REG_LOWER_LEVEL', 500) 
   
  if rospy.has_param('~REG_COUNT_NUM'):
   pass
  else:
   rospy.set_param('~REG_COUNT_NUM', 20)
   
  if rospy.has_param('~REG_SAVE_LENGTH'):
   pass
  else:
   rospy.set_param('~REG_SAVE_LENGTH', 8)
   
  if rospy.has_param('~REG_TIME_OUT'):
   pass
  else:
   rospy.set_param('~REG_TIME_OUT', 60)
   
  if rospy.has_param('~REG_NO_WORDS'):
   pass
  else:
   rospy.set_param('~REG_NO_WORDS', 6)
   
  if rospy.has_param('~REG_Api_Key'):
   pass
  else:
   rospy.set_param('~REG_Api_Key', "pmUzrWcsA3Ce7RB5rSqsvQt2")
   
  if rospy.has_param('~REG_Secrect_Key'):
   pass
  else:
   rospy.set_param('~REG_Secrect_Key', "d39ec848d016a8474c7c25e308b310c3")
   
  if rospy.has_param('~REG_Grant_type'):
   pass
  else:
   rospy.set_param('~REG_Grant_type', "client_credentials")
   
  if rospy.has_param('~REG_Token_url'):
   pass
  else:
   rospy.set_param('~REG_Token_url', "https://openapi.baidu.com/oauth/2.0/token")
   
  if rospy.has_param('~REG_Reg_url'):
   pass
  else:
   rospy.set_param('~REG_Reg_url', "http://vop.baidu.com/server_api")

  if rospy.has_param('~REG_USER_ID'):
   pass
  else:
   rospy.set_param('~REG_USER_ID', "8168466")
   
  if rospy.has_param('~REG_FORMAT'):
   pass
  else:
   rospy.set_param('~REG_FORMAT', "wav")
   
  if rospy.has_param('~REG_LAN'):
   pass
  else:
   rospy.set_param('~REG_LAN', "zh")
   
  if rospy.has_param('~REG_nchannel'):
   pass
  else:
   rospy.set_param('~REG_nchannel', 1)

   
  self.NUM_SAMPLES = rospy.get_param('~REG_NUM_SAMPLES') # default 2000 pyaudio内置缓冲大小
  #print 'self.NUM_SAMPLES',self.NUM_SAMPLES,type(self.NUM_SAMPLES)

  self.SAMPLING_RATE = rospy.get_param('~REG_SAMPLING_RATE')  # default 8000 取样频率
  #print 'self.SAMPLING_RATE',self.SAMPLING_RATE,type(self.SAMPLING_RATE)

  self.UPPER_LEVEL = rospy.get_param('~REG_UPPER_LEVEL') # default 5000 声音保存的阈值
  #print 'self.UPPER_LEVEL',self.UPPER_LEVEL,type(self.UPPER_LEVEL)

  self.LOWER_LEVEL = rospy.get_param('~REG_LOWER_LEVEL') # default 500 声音保存的阈值
  #print 'self.LOWER_LEVEL',self.LOWER_LEVEL,type(self.LOWER_LEVEL)

  self.COUNT_NUM = rospy.get_param('~REG_COUNT_NUM') # default 20 NUM_SAMPLES个取样之内出现COUNT_NUM个大于LOWER_LEVEL的取样则记录声音
  #print 'self.COUNT_NUM',self.COUNT_NUM,type(self.COUNT_NUM)

  self.SAVE_LENGTH = rospy.get_param('~REG_SAVE_LENGTH') # default 8 声音记录的最小长度：SAVE_LENGTH * NUM_SAMPLES 个取样
  #print 'self.SAVE_LENGTH',self.SAVE_LENGTH,type(self.SAVE_LENGTH)

  self.TIME_OUT = rospy.get_param('~REG_TIME_OUT') # default 60 录音时间，单位s
  #print 'self.TIME_OUT',self.TIME_OUT,type(self.TIME_OUT)

  self.NO_WORDS = rospy.get_param('~REG_NO_WORDS') # default 6
  #print 'self.NO_WORDS',self.NO_WORDS,type(self.NO_WORDS)

  self.Api_Key = rospy.get_param('~REG_Api_Key') # default "pmUzrWcsA3Ce7RB5rSqsvQt2"
  #print 'self.Api_Key',self.Api_Key,type(self.Api_Key)

  self.Secrect_Key = rospy.get_param('~REG_Secrect_Key') # default "d39ec848d016a8474c7c25e308b310c3"
  #print 'self.Secrect_Key',self.Secrect_Key,type(self.Secrect_Key)

  self.Grant_type = rospy.get_param('~REG_Grant_type') # default "client_credentials"
  #print 'self.Grant_type',self.Grant_type,type(self.Grant_type)

  self.Token_url = rospy.get_param('~REG_Token_url') # default 'https://openapi.baidu.com/oauth/2.0/token'
  #print 'self.Token_url',self.Token_url,type(self.Token_url)

  self.Reg_url = rospy.get_param('~REG_Reg_url') # default 'http://vop.baidu.com/server_api'
  #print 'self.Reg_url',self.Reg_url,type(self.Reg_url)

  self.USER_ID = rospy.get_param('~REG_USER_ID') # default '8168466'
  #print 'self.USER_ID',self.USER_ID,type(self.USER_ID)

  self.FORMAT = rospy.get_param('~REG_FORMAT') # default 'wav'
  #print 'self.FORMAT',self.FORMAT,type(self.FORMAT)

  self.LAN = rospy.get_param('~REG_LAN') # default 'zh'
  #print 'self.LAN',self.LAN,type(self.LAN)

  self.nchannel = rospy.get_param('~REG_nchannel') # default 1
  #print 'self.nchannel',self.nchannel,type(self.nchannel)

  self.Voice_String =        []
  
  
 #testing
  #print 'NUM_SAMPLES',type(self.nchannel)
  
  
 def Print_Response(self, data):
  for i in data:
   print ' ', i , ': ' , data[i]
   

 def recode(self):
  pa = PyAudio() 
  stream = pa.open(format=paInt16, channels=self.nchannel, rate=self.SAMPLING_RATE, input=True, frames_per_buffer=self.NUM_SAMPLES) 
  save_count = 0 
  save_buffer = [] 
  time_out = self.TIME_OUT
  NO_WORDS=self.NO_WORDS
  
  while True and NO_WORDS:
   time_out -= 1
   print 'time_out in', time_out # 读入NUM_SAMPLES个取样
   string_audio_data = stream.read(self.NUM_SAMPLES) # 将读入的数据转换为数组
   audio_data = np.fromstring(string_audio_data, dtype=np.short) 

   # 查看是否没有语音输入
   NO_WORDS -= 1
   if np.max(audio_data) > self.UPPER_LEVEL:
    NO_WORDS=self.NO_WORDS
   print 'self.NO_WORDS ', NO_WORDS
   print 'np.max(audio_data) ', np.max(audio_data)

   # 计算大于LOWER_LEVEL的取样的个数
   large_sample_count = np.sum( audio_data > self.LOWER_LEVEL )
   
   # 如果个数大于COUNT_NUM，则至少保存SAVE_LENGTH个块
   if large_sample_count > self.COUNT_NUM:
    save_count = self.SAVE_LENGTH 
   else: 
    save_count -= 1
   #print 'save_count',save_count
   
   # 将要保存的数据存放到save_buffer中
   if save_count < 0:
    save_count = 0 
   elif save_count > 0 : 
    save_buffer.append( string_audio_data ) 
   else:
    pass
    
   # 将save_buffer中的数据写入WAV文件，WAV文件的文件名是保存的时刻
   if len(save_buffer) > 0 and NO_WORDS==0: 
    self.Voice_String = save_buffer
    save_buffer = [] 
    rospy.loginfo( "Recode a piece of voice successfully!")
    #return self.Voice_String
    
   elif len(save_buffer) > 0 and time_out==0: 
    self.Voice_String = save_buffer
    save_buffer = [] 
    rospy.loginfo( "Recode a piece of voice successfully!")
    #return self.Voice_String
   else: 
    pass
   #rospy.loginfo( '\n\n')


 def conventor(self, Data_to_String):
  Voice_data=str()
  for Data in Data_to_String:
   Voice_data_h=array.array('b',Data)
   #print Voice_data_h
   Voice_data_h.byteswap()
   #print Voice_data_b
   Voice_data_s=Voice_data_h.tostring()
   Voice_data+=Voice_data_s
  return Voice_data
  
 def print_data_len(self,data):
  print len(data)
  n=0
  for i in data:
   n+=1
   print n

  ###########################################################
  ########################  testing  ########################
  ###########################################################  
   
 def savewav(self,filename):
  rospy.loginfo('存储音频')
  file_path='/home/turtlebot/xu_slam/src/simple_voice/src'
  WAVE_FILE = '%s/%s.wav'%(file_path,filename)
  wf = wave.open(WAVE_FILE, 'wb') 
  wf.setnchannels(1) 
  wf.setsampwidth(2) 
  wf.setframerate(self.SAMPLING_RATE) 
  wf.writeframes("".join(self.Voice_String)) 
  wf.close() 
  rospy.loginfo('音频数据已存')
      
if __name__=="__main__":
 rospy.init_node('simple_voice')
 rospy.loginfo("initialization system")
 recoder()
 rospy.loginfo("process done and quit")
