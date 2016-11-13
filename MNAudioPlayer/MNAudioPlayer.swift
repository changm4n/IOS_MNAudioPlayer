//
//  MNAudioPlayer.swift
//  MNAudioPlayer
//
//  Created by 이창민 on 2016. 11. 13..
//  Copyright © 2016년 MN. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol MNAudioPlayerDelegeate{
  func audioPlayerDidFinishPlaying(player:MNAudioPlayer)
}


class MNAudioPlayer : NSObject{
  
  var duration:Int!
  var isPlaying:Bool = false
  
  var currentTime:Int!{
    get{
      return currnetTime()
    }
  }
  private var _rate:Float!
  var rate:Float{
    get{
      return _rate
    }
    set{
      self.setRate(rate: newValue)
    }
  }
  
  var delegate:MNAudioPlayerDelegeate?
  
  var timer:Timer!
  
  var engine:AVAudioEngine!
  var playerNode:AVAudioPlayerNode!
  var eq:AVAudioUnitEQ!
  var rateEQ:AVAudioUnitTimePitch!
  var file:AVAudioFile!
  
  var pausedTime:Int!
  var seekedTime:Int!
  
  var url:URL!
  var frequencies:[Int]!
  var globalGain:Float!
  
  init(withContentOfURL url:URL , Frequencies:[Int]){
    
    super.init()
    
    self.url = url
    frequencies = Frequencies
    globalGain = 0.0
    
    initializeNodes()
    
  }
  
  convenience init(withContentOfURL url:URL) {
    
    self.init(withContentOfURL: url,Frequencies: [Int]())
    
  }
  
  func initializeNodes(){
    
    engine = AVAudioEngine()
    playerNode = AVAudioPlayerNode()
    if frequencies.count > 0 {
      eq = AVAudioUnitEQ(numberOfBands: frequencies.count)
      resetEQFrequencies()
    }else{
      eq = AVAudioUnitEQ()
    }
    
    rateEQ = AVAudioUnitTimePitch()
    
    
    do {
      try file = AVAudioFile(forReading: url)
    }catch{print("AVAudioFile init error")}
    
    
    eq.globalGain = globalGain
    
    engine.attach(playerNode)
    engine.attach(eq)
    engine.attach(rateEQ)
    
    
    engine.connect(playerNode, to: eq, format: file.processingFormat)
    engine.connect(eq, to: rateEQ, format: file.processingFormat)
    engine.connect(rateEQ, to:engine.mainMixerNode, format:file.processingFormat)
    
    playerNode.scheduleFile(file, at: nil, completionHandler: nil)
    
    do{
      try engine.start()
    }catch{print("AVAudioEngine Start Error")}
    
  }
  
  
  
  
  func play(){
    if playerNode.isPlaying == true{
      return
    }
    
    playerNode.play()
    isPlaying = true
    
  }
  
  func stop(){
    
    playerNode.stop()
    seekedTime = 0
    pausedTime = 0
    
    
  }
  
  func pause(){
    if playerNode.isPlaying == false{
      return
    }
    isPlaying = false
    
    pausedTime = Int(currnetTime())
    
    
  }
  
  func currnetTime()->Int{
    
    if isPlaying == true{
      let sampleRate = file.fileFormat.sampleRate
      
      if sampleRate == 0 {
        return 0
      }
      let nodetime: AVAudioTime  = playerNode.lastRenderTime!
      let playerTime: AVAudioTime = playerNode.playerTime(forNodeTime: nodetime)!
      let current = Double(playerTime.sampleTime) / sampleRate
      
      return Int(current)
      
      
    }else{
      return pausedTime
    }
    
    
  }
  
  
  
  
  
  func resetEQFrequencies(){
    guard eq != nil else {return}
    for (index,element) in frequencies.enumerated(){
      
      let parameter = eq.bands[index]
      parameter.filterType = .parametric
      parameter.frequency = Float(element)
      parameter.bandwidth = 1.0
      parameter.bypass = false
      parameter.gain = 0.0
      
    }
  }
  
  func setEQFrequencies(withGain gain:Float, forBand index:Int){
    guard eq != nil else {return}
    if index < frequencies.count{
      
      let parameter = eq.bands[index]
      parameter.gain = gain
      
      print("\(parameter.frequency) gain : \(gain)")
      
    }
  }
  
  func setRate(rate:Float){
    guard rateEQ != nil else{return}
    _rate = rate
    rateEQ.rate = rate
  }
  
  func setGlobalGain(gain:Float){
    guard eq != nil else {return}
    eq.globalGain = gain
  }
  
  
  
  
  
  
}
