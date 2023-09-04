//
//  NewSpeechView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import SwiftUI

struct NewSpeechView: View {
    var transcriptionController = TranscribeController()
    @ObservedObject var userInput = UserInputURL()
    @State private var errorMessage: String? = nil
    @EnvironmentObject var audioList: AudioList
    @EnvironmentObject var currentState: CurrentState
    
    var body: some View {
        GeometryReader { geometry in
            Color("BaseColor")
            ZStack {
                VStack{
                    HStack {
                        Button(action: {
                            currentState.options.remove(.isNewSpeech)
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
                
                VStack{
                    // text field
                    ZStack{
                        HStack{
                            Color.accentColor
                                .frame(width: 36, height: 52)
                                .padding()
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "link")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Spacer()
                        }
                        // CustomTextField(placeholder:"Enter URL here...", text: $userInput.content)
                        // TextField(placeholder:"Enter URL here...", text: $userInput.content)
                        TextField("Enter URL here...", text: $userInput.content)
                            .padding()
                            .textContentType(.none)
                            .padding(.leading, 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(height:52)
                            )
                    }
                    .padding(.bottom, 20)
                    .padding(.horizontal, 30)
                    .frame(height:52)
                    
                    
                    Button("Import") {
                        let result = transcriptionController.try_transcribe(text: userInput.content)
                        switch result {
                        case .success(let audio):
                            audioList.insert(audio)
                            self.currentState.options.insert(.isPlayer)
                            self.currentState.options.remove(.isNewSpeech)
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                } // 中央のボタンをテキストフィールド
                
                // エラー表示パーツ
                if let errorMessage = errorMessage{
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .offset(y: 90)
                        .padding(.horizontal, 30)
                }
            } // ZStack
        }
    }
}

//struct NewSpeechView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewSpeechView(contentState: .newSpeech)
//    }
//}
