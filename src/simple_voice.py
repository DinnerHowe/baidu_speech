#!/usr/bin/env python
# -*- coding: utf-8 -*-
"先存.wav然后识别"
from pyaudio import PyAudio, paInt16
import json,base64,os,sys,requests,wave,rospy
import numpy as np 

class recoder():

 def __init__(self):
  filename="testing"
  self.define()
  #self.recoder()
  #self.savewav(filename)
  self.reg(filename)

 def reg(self,filename):
 
  #获取token
  requestData = {       "grant_type":           self.Grant_type, 
                        "client_id":            self.Api_Key, 
                        "client_secret":        self.Secrect_Key}
  
  result = requests.post(url = self.Token_url, data = requestData)
  
  token_data = json.loads(result.text)
  
  #self.Print_Response(token_data)
  
  if 'access_token' in token_data:  
   token = token_data['access_token']    #获取的token
   rospy.loginfo('token获取成功\n')
  else:
   rospy.loginfo('token获取失败\n')
   
  #提交数据
  file_path=self.current_path()
  WAVE_FILE = '%s/%s.%s'%(file_path,filename,self.FORMAT)
  rospy.loginfo('uploading file : %s \n'%WAVE_FILE)

  
  f = wave.openfp(WAVE_FILE,"rb")
  params = f.getparams()
  nchannels, sampwidth, framerate, nframes = params[:4]
  str_data = f.readframes(nframes) #Reads and returns at most n frames of audio, as a string of bytes
  
  #print str_data,type(str_data)
  f.close()
  
  speech = base64.b64encode(str_data)

  size = len(str_data)

  #print 'size',size
  
  RegData = {   "format":       self.FORMAT,
                "rate":         framerate,
                "channel":      nchannels,
                "cuid":         self.USER_ID,
                "token":        token,
                "len":          size,
                "speech":       speech,
                "lan":          self.LAN}
                
  HTTP_HEADER=          {  'Content-Type':      'audio/%s;rate=%s'%(self.FORMAT,framerate),
                           'Content-length':    len(json.dumps(RegData))}

  r = requests.post(url = self.Reg_url, data = json.dumps(RegData, sort_keys=True), headers=HTTP_HEADER)
  
  #print json.dumps(RegData, sort_keys=True),type(json.dumps(RegData, sort_keys=True))
  
  rospy.loginfo('response header')
  self.Print_Response(r.headers)
  rospy.loginfo('response header\n')
  
  #处理JSON

  result = json.loads(r.text)
  #self.Print_Response(result)
  rospy.loginfo( 'result: %s \n'%result['err_msg'])#,type(result)

  
  if result[u'err_msg']=='success.':
   word = result['result'][0].encode('utf-8')
   if word!='':
    if word[len(word)-3:len(word)]=='，':
     rospy.loginfo('识别结果:　%s \n'%word[0:len(word)-3])
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
   
   
   
 def define(self):
  self.error_reason={3300:      '输入参数不正确',
                     3301:      '识别错误',
                     3302:      '验证失败',
                     3303:      '语音服务器后端问题',
                     3304:      '请求 GPS 过大，超过限额',
                     3305:      '产品线当前日请求数超过限额'}
                     
  self.NUM_SAMPLES = 2000      #pyaudio内置缓冲大小
  self.SAMPLING_RATE = 8000    #取样频率
  self.UPPER_LEVEL = 5000         #声音保存的阈值
  self.LOWER_LEVEL = 500         #声音保存的阈值
  self.COUNT_NUM = 20      #NUM_SAMPLES个取样之内出现COUNT_NUM个大于LOWER_LEVEL的取样则记录声音
  self.SAVE_LENGTH = 8         #声音记录的最小长度：SAVE_LENGTH * NUM_SAMPLES 个取样
  self.TIME_COUNT = 60     #录音时间，单位s

  self.NO_WORDS=10
  
  self.Api_Key =             "pmUzrWcsA3Ce7RB5rSqsvQt2"
  
  self.Secrect_Key =         "d39ec848d016a8474c7c25e308b310c3"
  
  self.Grant_type =          "client_credentials"
  
  self.Token_url =           'https://openapi.baidu.com/oauth/2.0/token'
  
  self.Reg_url =             'http://vop.baidu.com/server_api'
  
  self.USER_ID =             '8168466'
  
  self.FORMAT =              'wav'
  
  self.LAN =                 'zh'
 
  self.Voice_String = []
  
 def current_path(self):
  path=sys.path[0] 
  if os.path.isdir(path):
   return path
  elif os.path.isfile(path):
   return os.path.dirname(path)
  
 def Print_Response(self, data):
  for i in data:
   print ' ', i , ': ' , data[i]
   
 def savewav(self,filename):
  wf = wave.open(filename+'.wav', 'wb') 
  wf.setnchannels(1) 
  wf.setsampwidth(2) 
  wf.setframerate(self.SAMPLING_RATE) 
  wf.writeframes("".join(self.Voice_String)) 
  wf.close() 

 def recoder(self):
  pa = PyAudio() 
  stream = pa.open(format=paInt16, channels=1, rate=self.SAMPLING_RATE, input=True, frames_per_buffer=self.NUM_SAMPLES) 
  save_count = 0 
  save_buffer = [] 
  time_count = self.TIME_COUNT
  NO_WORDS=self.NO_WORDS
  
  while True and NO_WORDS:
   time_count -= 1
   rospy.loginfo( 'time_count %s'%time_count) # 读入NUM_SAMPLES个取样
   string_audio_data = stream.read(self.NUM_SAMPLES) # 将读入的数据转换为数组
   audio_data = np.fromstring(string_audio_data, dtype=np.short) 

   # 查看是否没有语音输入
   NO_WORDS -= 1
   if np.max(audio_data) > self.UPPER_LEVEL:
    NO_WORDS=self.NO_WORDS
   rospy.loginfo( 'self.NO_WORDS %s'%NO_WORDS)
   rospy.loginfo( 'np.max(audio_data) %s'%np.max(audio_data))

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
    return True
    
   if len(save_buffer) > 0 and time_count==0: 
    self.Voice_String = save_buffer
    save_buffer = [] 
    rospy.loginfo( "Recode a piece of voice successfully!")
    return True
   rospy.loginfo( '\n\n')
                    
if __name__=="__main__":
 rospy.init_node('simple_voice')
 rospy.loginfo("initialization system")
 recoder()
 rospy.loginfo("process done and quit")
