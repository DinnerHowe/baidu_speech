# -*- coding: utf-8 -*-
import wave,sys,os
import pylab as pl
import numpy as np

  

path=sys.path[0] 
if os.path.isdir(path):
 file_path=path
elif os.path.isfile(path):
 file_path=os.path.dirname(path)

filename="testing"

# 打开WAV文档
f = wave.open(r"%s/%s.wav"%(file_path,filename), "rb")

# 读取格式信息
# (nchannels, sampwidth, framerate, nframes, comptype, compname)
params = f.getparams()
nchannels, sampwidth, framerate, nframes = params[:4]
print nchannels, sampwidth, framerate, nframes
# 读取波形数据
str_data = f.readframes(nframes)
f.close()

#将波形数据转换为数组
wave_data = np.fromstring(str_data, dtype=np.short)
wave_data = wave_data.T
time = np.arange(0, nframes) * (1.0 / framerate)

print 'time',time,len(time)

print 'wave_data',wave_data,len(wave_data)



# 绘制波形
pl.subplot(211) 
pl.plot(time, wave_data)
pl.xlabel("time (seconds)")
pl.show()
