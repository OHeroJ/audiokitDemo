//
//  ViewController.swift
//  555opp
//
//  Created by mac on 2021/11/10.
//

import UIKit
import AudioKit
import AVFoundation


struct DynamicRangeCompressorData {
    var ratio: AUValue = 1
    var threshold: AUValue = 0.0
    var attackDuration: AUValue = 0.1
    var releaseDuration: AUValue = 0.1
    var rampDuration: AUValue = 0.02
    var balance: AUValue = 0.5
}

class DynamicRangeCompressorConductor: ObservableObject{
    let engine = AudioEngine()
    let player = AudioPlayer()
    let compressor: DynamicRangeCompressor
    let dryWetMixer: DryWetMixer
    let buffer: AVAudioPCMBuffer
    
    static var sourceBuffer: AVAudioPCMBuffer {
        let url = Bundle.main.resourceURL?.appendingPathComponent("Guitar.mp3")
        let file = try! AVAudioFile(forReading: url!)
        return try! AVAudioPCMBuffer(file: file)!
    }

    init() {
        buffer = DynamicRangeCompressorConductor.sourceBuffer
        player.buffer = buffer
        player.isLooping = true

        compressor = DynamicRangeCompressor(player)
        compressor.$threshold.ramp(to: 2, duration: 0.2)
    
        dryWetMixer = DryWetMixer(player, compressor)
        engine.output = dryWetMixer
        
    }

    func start() {
        do { try engine.start() } catch let err { Log(err) }
    }

    func stop() {
        engine.stop()
    }
}


class ViewController: UIViewController {
    
    var conductor = DynamicRangeCompressorConductor()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.conductor.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.conductor.stop()
    }


}

