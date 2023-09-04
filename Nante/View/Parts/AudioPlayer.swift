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
    @ObservedObject var audioList: AudioList
    private var timeObserver: Any?
    
    init(audioList:AudioList){
        self.audioList = audioList
        guard let index = audioList.selectionIndex, let items = audioList.items else {return}
        player = AVPlayer(url: items[index].resourceURL)
        addTimeObserver()
    }

    func setTime(duration: TimeInterval, progress: Double){
        let newTime = CMTimeMakeWithSeconds(progress * duration, preferredTimescale: 600)
        player?.seek(to: newTime)
    }
    
    func play(){
        if let player = player{
            player.play()
        } else {
            if let index = audioList.selectionIndex, let items = audioList.items {
                player = AVPlayer(url: items[index].resourceURL)
                player!.play()
                addTimeObserver()
            }
        }
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

    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) {
            [weak self] time in
            guard let duration = self?.player?.currentItem?.duration.seconds else { return }
            guard let index = self?.audioList.selectionIndex, let items = self?.audioList.items else { return }
            items[index].progress.value = time.seconds / duration
        }
    }

    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }

    deinit {
        removeTimeObserver()
    }
}
