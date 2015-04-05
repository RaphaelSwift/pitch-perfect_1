//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Raphael Neuenschwander on 24.01.15.
//  Copyright (c) 2015 Raphael. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //Convert a String to a NSURL
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile=AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
        
        
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlow(sender: UIButton) {
        //play it slowwwwwwwly....
        playTempoRate(0.5)
    }
    
    @IBAction func playFast(sender: UIButton) {
        //play it fast!!!
        playTempoRate(2)
    }
    
    // play at a defined playing rate
    func playTempoRate (tempo: Float){
    stopAndResetAudio()
    audioPlayer.rate = tempo
    audioPlayer.currentTime = 0.0
    audioPlayer.play()
    
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    @IBAction func playWithReverb(sender: UIButton) {
    playAudioWithReverb(90)
    
    }
    
    // Play audio with variable effect
    
    func playAudioWithVariableEffect(effect: AVAudioUnit) {
        stopAndResetAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    // Play with reverb effect
    func playAudioWithReverb (reverb: Float){
        
        var changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.wetDryMix = reverb
        playAudioWithVariableEffect(changeReverbEffect)
    
    }
    
    // Play with diffferent pitch effect
    func playAudioWithVariablePitch(pitch: Float){

        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        playAudioWithVariableEffect(changePitchEffect)
    }
    
    // Stop all audio from playing and reset the "engine"
    func stopAndResetAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        // stop all audio from playing
        stopAndResetAudio()
        
    }

}
