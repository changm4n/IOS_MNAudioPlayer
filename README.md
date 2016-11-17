# IOS_MNAudioPlayer

## Features
* Frequency 별 Gain값 변경을 통한 **Equalizer**
* 0.3배 ~ 3배 **배속재생**
* 위 2가지 조건을 **Preset으로 지정**
* 저장된 Preset들을 Time interval마다  **실시간 재생에 순차적으로 적용** 

## Requirements
* IOS 9.3+
* Swift 3

## How to use this sample
1. 하단의 재생버튼 터치
2. 노래가 재생되면, 상단의 UISlider를 통하여 Equalizer 조정
3. 지정된 Presets버튼을 눌러서 적용
4. 순차적용 버튼을 터치 **Interval에 따른 번화 확인**


## Issue
* 볼륨조절 기능 -  UISlider를 이용하지 않고, Private API를 통해 Device volume을 조절하는건 **Reject사유가 된다고 합니다.**
