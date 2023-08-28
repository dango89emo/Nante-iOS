//
//  PlayerManager.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/28.
//

import SwiftUI
import AVFoundation

class AudioPlayer: ObservableObject {
    private var player: AVPlayer?
    @Published var isPlaying: Bool = false
    
    func play(url: URL) {
        player = AVPlayer(url: url)
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func rewind(by seconds: Double) {
        guard let currentTime = player?.currentTime() else { return }
        let newTime = CMTimeSubtract(currentTime, CMTimeMakeWithSeconds(seconds, preferredTimescale: 600))
        player?.seek(to: newTime)
    }
    
    func forward(by seconds: Double) {
        guard let currentTime = player?.currentTime() else { return }
        let newTime = CMTimeAdd(currentTime, CMTimeMakeWithSeconds(seconds, preferredTimescale: 600))
        player?.seek(to: newTime)
    }
}
