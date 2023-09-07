//
//  PlayerManager.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/28.
//

import SwiftUI
import AVFoundation
import Combine

class AudioPlayer: ObservableObject {
    private var player: AVPlayer?
    @Published var isPlaying: Bool = false
    @ObservedObject var audioList: AudioList
    private var timeObserver: Any?
    private var cancellables: Set<AnyCancellable> = []
    private var lastIndex: Int?
    private var itemCount: Int?
    private var isProgrammaticChange: Bool = false
    
    init(audioList:AudioList){
        self.audioList = audioList
        if let index = audioList.selectionIndex, let items = audioList.items {
            let player = AVPlayer(url: items[index].resourceURL)
            self.player = player
            self.lastIndex = index
            self.itemCount = items.count
        }
        
        addTimeObserver()
        
        /*
         newSpeechの追加場面や、ナビゲーションでの選択変更などの場合の処理
         selectionIndexに値が代入される。
         */
        audioList.$selectionIndex
            .sink(receiveValue: { [weak self] newIndex in
                guard let index = newIndex, let items = audioList.items else { return }
                
                // 何も変わっていない場合の処理：
                if let lastIndex = self?.lastIndex, let itemCount = self?.itemCount {
                    if(lastIndex == index && itemCount == items.count) { return }
                }
                
                self?.removeTimeObserver()
                let player = AVPlayer(url: items[index].resourceURL)
                self?.player = player
                self?.pause()
                let duration = items[index].duration
                let progress = items[index].progress.value
                self?.setTime(duration: duration, progress: progress)
                self?.addTimeObserver()
                self?.lastIndex = index
                self?.itemCount = items.count
            }).store(in: &cancellables)
        
        /*audioList.$items
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] items in
                items.forEach { audio in
                    audio.$progress.sink { [weak self] newProgress in
                        guard let index = self?.audioList.selectionIndex, index < items.count else { return }
                        let selectedAudio = items[index]
                        if audio === selectedAudio { // 比較して選択されているオーディオと同じであることを確認
                            let duration = selectedAudio.duration
                            self?.setTime(duration: duration, progress: newProgress.value)
                        }
                    }.store(in: &self!.cancellables)
                }
            }).store(in: &cancellables)*/
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) {
            [weak self] time in
            guard let player = self?.player else { return }
            guard let item = player.currentItem, !item.duration.isIndefinite else { return }
            let duration = item.duration.seconds
            if duration.isNaN || time.seconds.isNaN { return }
            guard let index = self?.audioList.selectionIndex, let items = self?.audioList.items else { return }
            self?.isProgrammaticChange = true
            items[index].progress.value = time.seconds / duration
            self?.isProgrammaticChange = false
        }
    }

    private func removeTimeObserver() {
        guard let observer = timeObserver else { return }
        player?.removeTimeObserver(observer)
        timeObserver = nil
    }

    func setTime(duration: TimeInterval, progress: Double){
        let newTime = CMTimeMakeWithSeconds(progress * duration, preferredTimescale: 600)
        player?.seek(to: newTime)
    }
    
    func play(){
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func rewind(by seconds: Double) {
        if let currentTime = player?.currentTime(){
            let newTime = CMTimeSubtract(currentTime, CMTimeMakeWithSeconds(seconds, preferredTimescale: 600))
            player?.seek(to: newTime)
        }
    }
    
    func forward(by seconds: Double) {
        if let currentTime = player?.currentTime(){
            let newTime = CMTimeAdd(currentTime, CMTimeMakeWithSeconds(seconds, preferredTimescale: 600))
            player?.seek(to: newTime)
        }
    }

    deinit {
        removeTimeObserver()
    }
}
