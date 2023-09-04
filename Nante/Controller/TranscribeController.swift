//
//  ResourceURL.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/01.
//

import Foundation

enum TranscriptionError: Error{
    case invalidURL
    case notImplementedPlatform
    case resourceNotFound
    case apiError
}

struct TranscribeController {
    var transcriber = Transcriber()
    
    mutating func try_transcribe(text: String) -> Result<Audio, TranscriptionError>{
        guard let url = URL(string: text) else {
            return .failure(.invalidURL)
        }
        if (transcriber.checkPlatform(input: url)) {
            return .failure(.notImplementedPlatform)
        }
        guard let audio = transcriber.makeAudio(input: url) else {
            return .failure(.resourceNotFound)
        }
        return .success(audio)
    }
}
