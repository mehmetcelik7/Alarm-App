//
//  Play Sound.swift
//  Alarm App
//
//  Created by mehmet Çelik on 16.03.2025.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer? = AVAudioPlayer()

func playSound(sound: String, type: String = "", volume: Float = 1.0) {
    
    if let path = Bundle
        .main
        .path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
            audioPlayer?.setVolume(volume, fadeDuration: 0.1)
            
            audioPlayer?.play()
            
        }catch {
            print("audio ERROR")
        }
    }
}

func stopPlaying() {
    audioPlayer?.stop()
}
