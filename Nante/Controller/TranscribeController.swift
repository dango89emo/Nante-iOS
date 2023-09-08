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
    case nanteAPIError
    case unknownError
    
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
        case .nanteAPIError:
            return "サーバーとの通信で問題が生じました"
        case .unknownError:
            return "不明なエラーが生じました"
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
    func transcribe(audio: Audio) async -> Result<Transcription, TranscriptionError>{
        let decoder = JSONDecoder()
        
        let handle = Task {
            let result = await fetch(url: nanteAPIData.domain, httpMethod: .get)
            return result
        }
        
        let result = await handle.value
        switch result{
        case .success(let res):
            guard let transcription = try? decoder.decode(Transcription.self, from: res) else {
                return .failure(.jsonDecodeError)
            }
            return .success(transcription)
            
        case .failure(let error):
            if error == .noDataReceived{
                return .failure(.nanteAPIError)
            }else{
                return .failure(.nanteAPIError)
            }
        }
    }
}
