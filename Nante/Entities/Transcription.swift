//
//  Transcription.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/01.
//

import Foundation


struct Word: Decodable {
    let startTime: String
    let endTime: String
    let word: String
}

struct Sentence: Decodable {
    let transcript: String
    let confidence: Double
    let words: [Word]
}

struct Transcription {
    let content : [Sentence]
}
