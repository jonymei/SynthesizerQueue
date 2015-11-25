# SynthesizerQueue
## 说明
讯飞语音合成IFlySpeechSynthesizer的一种调用方式，是针对长文本如小说类，提出的新的调用思路。目的是为了减少两段语音之间的间隔，听起来更加自然流畅。原理是分离合成和播放的过程，最大化合成的效率，通过串行合成文本、播放音频达到预期的目标。

## 使用方式
* ###申请APPID
在[讯飞语音云](http://www.xfyun.cn)上申请注册应用，获取**APPID**，并将**APPID**填入AppDelegate.m提示位置。
* ####下载SDK
由于讯飞语音SDK本身与**APPID**绑定，不方便使用CocoaPods管理，需要下载后放到工程libs 目录下。 
 