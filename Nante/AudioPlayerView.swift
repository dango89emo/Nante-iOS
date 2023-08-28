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
        VStack {
            TextField("音声ストリームのURLを入力してください", text: $audioURLString)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
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

