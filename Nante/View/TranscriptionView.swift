//
//  TranscriptionView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/07.
//

import SwiftUI

struct TranscriptionView: View {
    let transcription: Transcription
    let duration: Double
    @State private var currentWord: Word?
    @EnvironmentObject var progress: ProgressModel // この値を実際の音楽の再生時間で更新する必要があります。
    @EnvironmentObject var audioPlayer: AudioPlayer
    
    init(transcription: Transcription, duration: Double){
        self.transcription = transcription
        self.duration = duration
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(transcription.content, id: \.self) { sentence in
                        createRowViews(for: sentence, geometryWidth: geometry.size.width)
                    }
                }
            }
         }
    }

    private func createRowViews(for sentence: Sentence, geometryWidth: CGFloat) -> some View {
        var totalWidth: CGFloat = 0
        var lineWords: [Word] = []
        var lines: [[Word]] = [] // Change the type to array of array of Word
        let spaceWidth = 5.0
        for word in sentence.words {
            let wordWidth = getTextWidth(text: word.word) + spaceWidth

            if totalWidth + wordWidth > geometryWidth * 0.8 {
                lines.append(lineWords) // No need to call createLine(from:) here
                lineWords.removeAll()
                totalWidth = 0
            }

            lineWords.append(word)
            totalWidth += wordWidth
        }

        if !lineWords.isEmpty {
            lines.append(lineWords)
        }

        return VStack(alignment: .leading, spacing: spaceWidth) {
            ForEach(lines, id: \.self) { lineWords in
                HStack {
                    ForEach(lineWords, id: \.word) { word in
                        Text("\(word.word)")
                            .lineLimit(1)
                            .textSelection(.enabled)
                            .background((word.startTime <= progress.value * duration) && (progress.value * duration < word.endTime) ? Color("WeakAccentColor") : Color.clear)
                            .onTapGesture {
                                self.currentWord = word
                                self.progress.value = word.startTime / duration
                                audioPlayer.setTime(duration: duration, progress: progress.value)
                            }
                    }
                }.padding(.horizontal, geometryWidth * 0.05)
            }
        }
    }
              
    private func getTextWidth(text: String) -> CGFloat {
      // テキストの幅を取得するための仮のTextビューを使用
      let label = UILabel()
      label.text = text
      label.sizeToFit()
      return label.frame.width
    }
}

//struct TranscriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        TranscriptionView()
//    }
//}
