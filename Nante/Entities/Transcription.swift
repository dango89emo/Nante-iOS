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

class Sentence: Decodable, Identifiable, Hashable {
    let id: UUID
    let transcript: String
    let confidence: Double
    let words: [Word]
    init(transcript: String, confidence: Double, words: [Word]){
        self.id = UUID()
        self.transcript = transcript
        self.confidence = confidence
        self.words = words
    }
    static func == (leftHandSide: Sentence, rightHandSide: Sentence) -> Bool {
            return leftHandSide.id == rightHandSide.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Transcription {
    let content : [Sentence]
}
