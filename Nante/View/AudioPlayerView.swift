//
//  AudioPlayerView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/28.
//

import SwiftUI
import AVFoundation
import Combine

struct AudioPlayerView: View {
    let imageHeight = 25.0
    let imageWidth = 23.0
    
    @EnvironmentObject var audioPlayer: AudioPlayer
    @EnvironmentObject var currentState: CurrentState
    @EnvironmentObject var audioList: AudioList
    @State var progress = ProgressModel()
    @State private var lastIndex: Int?
    @State private var lastItemCount: Int?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack{
                    // Header
                    HStack {
                        Button(action: {
                            currentState.options.remove(.isPlayer)
                        }) {
                            Image(systemName: "chevron.left") // SF Symbols の左向き矢印を利用
                                .resizable() // 画像のサイズを変更可能にする
                                .frame(width: 10, height: 15)
                                .foregroundColor(.black) // またはあなたの望む色に変更
                                .padding(30)
                        }
                        if let items = audioList.items, let index = audioList.selectionIndex{
                            Text(items[index].title)
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .padding(.trailing, 30)
                        }
                        Spacer()
                    }
                    
                    // Content
                    if let items = audioList.items,
                       let index = audioList.selectionIndex,
                       let transcription = items[index].transcription {
                        TranscriptionView(transcription: transcription, duration: items[index].duration)
                            .environmentObject(items[index].progress)
                            .environmentObject(audioPlayer)
                    } else {
                        Spacer()
                        VStack{
                            ProgressView()
                                .scaleEffect(3.0)
                            Text("AIが文字起こしをしています。しばらくお待ちください。")
                                .frame(width: geometry.size.width * 0.8)
                                .foregroundColor(.gray)
                                .offset(y: 50)
                        }
                        Spacer()
                    }
                    Spacer()
                    
                    // Footer
                    VStack {
                        VStack{
                          
                            ProgressBar(progress: self.progress)
                            HStack {
                                ProgressGauge(progress: self.progress).foregroundColor(.clear)
                                Button(action: {
                                    audioPlayer.rewind(by: 10.0)
                                }) {
                                    Image(systemName: "gobackward.10")
                                        .resizable()
                                        .frame(width: imageWidth, height: imageHeight)
                                }
                                .padding()
                                
                                Button(action: {
                                    if audioPlayer.isPlaying {
                                        audioPlayer.pause()
                                    } else {
                                        audioPlayer.play()
                                    }
                                }) {
                                    Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                                        .resizable()
                                        .frame(width: imageWidth, height: imageHeight)
                                }
                                .padding()
                                
                                Button(action: {
                                    audioPlayer.forward(by: 10.0)
                                }) {
                                    Image(systemName: "goforward.10")
                                        .resizable()
                                        .frame(width: imageWidth, height: imageHeight)
                                }
                                .padding()
                                ProgressGauge(progress: self.progress)
                            }
                            .frame(width: geometry.size.width)
                        }
                        .background(Color.white)
                        .onReceive(
                            audioList.$selectionIndex,
                            perform: { newIndex in
                                // 新しい状態にて、選択状態がなかったり、一つもaudioがないなら、何もしない。
                                guard let newIndex = newIndex, let items = audioList.items else {
                                    self.progress = ProgressModel()
                                    return
                                }
                                // 以前に再生したものがある場合
                                if let unwrappedLastIndex = lastIndex,
                                   let unwrappedLastItemCount = lastItemCount
                                {//変化があった場合のみ
                                    if newIndex != unwrappedLastIndex || unwrappedLastItemCount != items.count{
                                        self.progress = items[newIndex].progress
                                    }
                                // 変化がなかった場合何もしない
                                // 初めての再生の場合
                                }else{
                                    self.progress = items[newIndex].progress
                                }
                                self.lastIndex = newIndex
                                self.lastItemCount = items.count
                        }) // perform
                    }
                }
            }
        }
    }
}
