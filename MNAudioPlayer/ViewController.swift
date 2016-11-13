//
//  ViewController.swift
//  MNAudioPlayer
//
//  Created by 이창민 on 2016. 11. 13..
//  Copyright © 2016년 MN. All rights reserved.
//

import UIKit
import Foundation
class ViewController: UIViewController {

  
  
  var timer:Timer!
  var player:MNAudioPlayer!
  let rate:[Float] = [0.3,1,2,3]
  var tick = 0
  let presets:[[Float]] = [[0,-10,-30,0,1],[-5,0,10,20,2],[-5,0,-10,20,3]]
  
  
  @IBOutlet var collectionOfButtons: Array<UIButton>?
  @IBOutlet var collectionOfSliders: Array<UISlider>?
  @IBOutlet var palyTimeLabel: UILabel!
  @IBOutlet var segmentControl: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let filepath = Bundle.main.path(forResource: "overtime", ofType: "mp3")
    let fileURL = URL(fileURLWithPath: filepath!)
    
    player = MNAudioPlayer(withContentOfURL: fileURL, Frequencies: [100,500,2000,16000])
    
    
    
    
    
  }


  @IBAction func startButton(_ sender: AnyObject) {
    player.play()
    
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
      self.updateTime()
    }
    
  }
  
  @IBAction func sliderChanged(_ sender: UISlider) {
    
    player.setEQFrequencies(withGain: sender.value, forBand: sender.tag)
    
  }
  
  func updateTime(){
    
    palyTimeLabel.text = "재생시간 : \(player.currentTime!)sec"
    print(player.currentTime)
    
  }
  
  @IBAction func resetEQ(_ sender: AnyObject) {
    
    for slider in collectionOfSliders!{
      slider.setValue(0, animated: true)
    }
    segmentControl.selectedSegmentIndex = 1
    
    
    player.setRate(rate: 1)
    player.resetEQFrequencies()
    
  }
  
  @IBAction func presetButton(_ sender: UIButton) {
    
    selectPresetButton(index: sender.tag)
    let preset = presets[sender.tag]
    let rate = preset[preset.count-1]
    for (index,slider) in collectionOfSliders!.enumerated(){
      
      slider.setValue(preset[index], animated: true)
      player.setEQFrequencies(withGain: preset[index], forBand: index)
    }
    
    segmentControl.selectedSegmentIndex = Int(rate)
    player.setRate(rate: rate)
    
  }
  
  func selectPresetButton(index:Int){
    
    for (idx,button) in collectionOfButtons!.enumerated(){
      if idx == index{
        button.isSelected = true
      }else{
        button.isSelected = false
      }
    }
    
  }
  
  @IBAction func rateValueChanged(_ sender: UISegmentedControl) {
    
    player.setRate(rate: rate[sender.selectedSegmentIndex])
    
  }
  
  
  
  @IBAction func sequenceButtonPressed(_ sender: UIButton) {
    
    if sender.isSelected == true{
      
      timer.invalidate()
      tick = 0
      
    }else{
      
      Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_timer) in
        self.timer = _timer
        self.tick = self.tick + 1
        self.presetButton(self.collectionOfButtons![self.tick%3])
        
      }
      
    }
    
    sender.isSelected = !sender.isSelected
    
    
  }
  
  
  
}


