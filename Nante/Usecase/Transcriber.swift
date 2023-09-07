//
//  Transcribe.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import Foundation

struct AudioSpecifier{
    let resourceURL: URL
    let title: String
//    let publishDate: Date
    let duration: TimeInterval
    let platformSpecificMetadata: String?
}

struct Transcriber{
    var platformAdapter = PlatformAdapter()
    
    mutating func checkPlatform(input: URL) -> Bool{
        let host = input.host! // controllerでhostを持っているかどうかはチェックする。
        return platformAdapter.judge(host: host)
    }
    
    mutating func makeAudio(input: URL) -> Result<Audio, TranscriptionError>{
        platformAdapter.setInput(input: input)
        let res = platformAdapter.makeAudioSpecifier()
        switch res {
        case .success(let audioSpecifier):
            return .success(Audio(
                audioSpecifier.resourceURL,
                audioSpecifier.title,
    //            audioSpecifier.publishDate,
                audioSpecifier.duration,
                audioSpecifier.platformSpecificMetadata
            ))
        case .failure(let transcriptionError):
            return .failure(transcriptionError)
        }
    }
}
