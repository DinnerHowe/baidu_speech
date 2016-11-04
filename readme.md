# this package is python package for ROS speech, which use online baidu speech to do TTS and speech recognition.

# this code is run well in ubuntu 14.04, thinkpad T44s.

# you can visit the baidu speech home page at here: http://yuyin.baidu.com/

# the key and id is show below, feel free to change it in simple_speaker.launch and simple_voice.launch.


App ID: 8168466

API Key: pmUzrWcsA3Ce7RB5rSqsvQt2

Secret Key: d39ec848d016a8474c7c25e308b310c3

# subscribe topic
speak_string
#type
string

# How to run:

Speech Recognition:　roslaunch simple_voice simple_voice.launch

Text To Speech:  roslaunch simple_voice simple_speaker.launch

# wiki
http://wiki.ros.org/baidu_speech

