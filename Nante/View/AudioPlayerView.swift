//
//  AudioPlayerView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/28.
//

import SwiftUI
import AVFoundation

struct AudioPlayerView: View {
    let imageHeight = 25.0
    let imageWidth = 23.0
    
//    @ObservedObject var progress: ProgressModel
    @ObservedObject var audioPlayer: AudioPlayer
    @EnvironmentObject var currentState: CurrentState
    @EnvironmentObject var audioList: AudioList
    @State private var singleSelection = Set<UUID>()
    
    init(audioPlayer: AudioPlayer){
        self.audioPlayer = audioPlayer
    }
    
    var body: some View {
        Color("BaseColor")
        GeometryReader { geometry in
            ZStack{
                VStack{
                    // 戻るボタン
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
                        }
                        Spacer()
                    }
                    if let items = audioList.items, let index = audioList.selectionIndex, let transcription = items[index].transcription {
                        let sentences = transcription.content
                        ScrollView {
                            VStack {
                                ForEach(sentences, id: \.self) { sentence in
                                    Text(sentence.transcript)
                                        .padding()
                                }
                            }
                        }
                    } else {
                        Spacer()
                        VStack{
                            ProgressView()
                                .scaleEffect(3.0)
                            Text("AIが文字起こしをしています。しばらくお待ちください。")
                                .frame(width: geometry.size.width*0.8)
                                .offset(y: 50)
                                .foregroundColor(.gray)
                        }.offset(y: 70)
                    }
                    Spacer()
                }
                .frame(height: geometry.size.height)
                .offset(y: -1 * geometry.size.height) // なぜか高さが画面の半分として計算されているので、これがないと真ん中に表示される。
        
                
//                .frame(width: geometry.size.width, height: geometry.size.height)
//                .offset(y: -1 * geometry.size.height)
//
                
                // Audio Player
                VStack {
                    Spacer()
                    if let items = audioList.items, let index = audioList.selectionIndex{
                        @ObservedObject var progress = items[index].progress
                        ProgressBar(progress: progress)
                    }
                    HStack {
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
                    }
                    .frame(width: geometry.size.width)
                }
            }
        }
    }
}

