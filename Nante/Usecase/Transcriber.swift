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
    let publishDate: Date
    let platformSpecificMetadata: String
}

struct Transcriber{
    var platformAdapter = PlatformAdapter()
    
    mutating func checkPlatform(input: URL) -> Bool{
        if let host = input.host {
            return platformAdapter.judge(host: host)
        } else {
            return false
        }
    }
    
    func makeAudio(input: URL) -> Audio?{
        platformAdapter.setInput(input: input)
        guard let audioSpecifier = platformAdapter.makeAudioSpecifier() else{
            return nil
        }
    
        return Audio(
            audioSpecifier.resourceURL,
            audioSpecifier.title,
            audioSpecifier.publishDate,
            audioSpecifier.platformSpecificMetadata
        )
    }
}
