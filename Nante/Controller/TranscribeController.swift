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
    case durationConversionError
    case fileNotFound
    case jsonDecodeError
    case titleNotFoundError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "あなたの入力は、正式なURLの形式をしていません。"
        case .notImplementedPlatform:
            return "入力されたプラットフォームには現在対応していません。"
        case .resourceNotFound:
            return "データ解析に失敗しました(Error000)"
        case .fileNotFound:
            return "内部保存データの読み込みに失敗しました"
        case .jsonDecodeError:
            return "Jsonファイルの変換に失敗しました。"
        case .titleNotFoundError:
            return "データ解析に失敗しました(Error001)"
        case .durationConversionError:
            return "データ解析に失敗しました(Error002)"
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
        
        let res = transcriber.makeAudio(input: url)
        switch res{
        case .success(let audio):
            return .success(audio)
        case .failure(let error):
            return .failure(error)
        }
    }
    func transcribe(audio: Audio) -> Result<Transcription, TranscriptionError>{
        
//        sleep(5)
        
        let decoder = JSONDecoder()
        guard let url = Bundle.main.url(forResource: "sampleTranscription", withExtension: "json") else {
            return .failure(.fileNotFound)
        }
         
        guard let data = try? Data(contentsOf: url) else {
            return .failure(.fileNotFound)
        }
        
        guard let sentences = try? decoder.decode([Sentence].self, from: data) else {
            return .failure(.jsonDecodeError)
        }
        return .success(Transcription(content: sentences))
    }
}
