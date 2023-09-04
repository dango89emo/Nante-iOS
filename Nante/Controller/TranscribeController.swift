//
//  ResourceURL.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/01.
//

import Foundation

enum TranscriptionError: Error, LocalizedError{
    case invalidURL
    case notImplementedPlatform
    case resourceNotFound
//    case apiError
//    case unknownError
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "あなたの入力は、正式なURLの形式をしていません。"
        case .notImplementedPlatform:
            return "入力されたプラットフォームには現在対応していません。"
        case .resourceNotFound:
            return "データ取得の最中にエラーが起きました。"
        }
        
    }
}

class UserInputURL: ObservableObject{
    @Published var content: String = ""
}

class TranscribeController {
    var transcriber = Transcriber()
    
    init(){}
    
    func getAudio(text: String) -> Result<Audio, TranscriptionError>{
        // is valid url?
        guard let url = URL(string: text),
              let scheme = url.scheme,
              let _ = url.host,
              ["http", "https"].contains(scheme)  else {
            return .failure(.invalidURL)
        } // TODO: textとして"A"を入力したときに、このチェックを抜けられるかどうかを確かめるテストを書く
        if (!transcriber.checkPlatform(input: url)) {
            return .failure(.notImplementedPlatform)
        }
        guard let audio = transcriber.makeAudio(input: url) else {
            return .failure(.resourceNotFound)
        }
        return .success(audio)
    }
    func transcribe(audio: Audio) -> Result<Transcription, TranscriptionError>{
        return .success(Transcription(content: [sampleSentence]))
    }
}
