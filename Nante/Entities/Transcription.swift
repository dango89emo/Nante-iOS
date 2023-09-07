//
//  Transcription.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/01.
//

import Foundation


struct Word: Decodable, Hashable {
    let startTime: Double
    let endTime: Double
    let word: String
    
    enum CodingKeys: String, CodingKey {
        case startTime
        case endTime
        case word
    }
    
    init(startTime: Double, endTime: Double, word: String){
        self.startTime=startTime
        self.endTime=endTime
        self.word=word
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let startTimeString = try container.decode(String.self, forKey: .startTime)
        let endTimeString = try container.decode(String.self, forKey: .endTime)
        
        // 文字列から "s" を削除し、Double に変換
        startTime = Word.timeInterval(from: startTimeString) ?? 0.0
        endTime = Word.timeInterval(from: endTimeString) ?? 0.0
        
        word = try container.decode(String.self, forKey: .word)
    }
    
    static func timeInterval(from timeString: String) -> Double? {
        let stringWithoutS = timeString.trimmingCharacters(in: CharacterSet(charactersIn: "s"))
        return Double(stringWithoutS)
    }
}

class Sentence: Decodable, Identifiable, Hashable {
    let id = UUID()
    let transcript: String
    let confidence: Double
    let words: [Word]
    init(transcript: String, confidence: Double, words: [Word]){
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
