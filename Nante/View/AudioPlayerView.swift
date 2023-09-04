//
//  AudioPlayerView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/28.
//

import SwiftUI
import AVFoundation

struct AudioPlayerView: View {
    @State private var audioURLString: String = ""
    @ObservedObject private var audioPlayer = AudioPlayer()
    
    var body: some View {
        Color("BaseColor")
        ZStack{
            
            // 戻るボタン
            VStack{
                HStack {
                    Button(action: {
                        currentState.options.remove(.isPlayer)
                    }) {
                        Image(systemName: "chevron.left") // SF Symbols の左向き矢印を利用
                            .resizable() // 画像のサイズを変更可能にする
                            .frame(width: 15, height: 15) // 画像のサイズを40x40に設定
                            .foregroundColor(.black) // またはあなたの望む色に変更
                            .padding(30)
                    }
                    Spacer()
                }
                Spacer()
            }
            
            // Audio Player
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        audioPlayer.rewind(by: 10.0)
                    }) {
                        Image(systemName: "gobackward.10")
                    }
                    .padding()
                    
                    Button(action: {
                        if audioPlayer.isPlaying {
                            audioPlayer.pause()
                        } else if let url = URL(string: audioURLString) {
                            audioPlayer.play(url: url)
                        }
                    }) {
                        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                    }
                    .padding()
                    
                    Button(action: {
                        audioPlayer.forward(by: 10.0)
                    }) {
                        Image(systemName: "goforward.10")
                    }
                    .padding()
                }
            }
        }
    }
}

