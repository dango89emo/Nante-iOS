//
//  NewSpeechView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import SwiftUI

struct NewSpeechView: View {
    @Binding var contentState: ContentStateType
    @ObservedObject var userInput = UserInputURL()
    @State private var errorMessage: String? = nil
    @EnvironmentObject var transcriptionList: TranscriptionList
    
    var body: some View {
        Color("BaseColor")
        VStack(spacing: 0) {
            ZStack {
                HStack{
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
                        
                    }
                }
                CustomTextField(placeholder:"Enter URL here...", text: $userInput.text)
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
            .frame(height:52)
            
            Button("Import") {
                let result = userInput.parse()
                switch result {
                case .success(let url):
                    let apiResult = transcriber.act_on(input: url)
                    switch apiResult {
                    case .success(let transcription):
                        contentState = .player
                        transcriptionList.insert(transcription)
                    case .failure(let apiError):
                        self.errorMessage = apiError.localizedDescription
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(20)
        }
        .padding()
    }
}

//struct NewSpeechView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewSpeechView(contentState: .newSpeech)
//    }
//}
