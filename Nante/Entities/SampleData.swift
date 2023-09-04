//
//  SampleData.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import Foundation

let sampleSentence = Sentence(
    transcript: "Four score and twenty",
    confidence: 0.98,
    words: [
        Word(
            startTime: "1.300s",
            endTime: "1.400s",
            word: "Four"
        ),
        Word(
            startTime: "1.400s",
            endTime: "1.600s",
            word: "score"
        ),
        Word(
            startTime: "1.600s",
            endTime: "1.600s",
            word: "and"
        ),
        Word(
            startTime: "1.600s",
            endTime: "1.900s",
            word: "twenty"
        )
    ]
)

let samplePayload = """
[
    {
      "transcript": "Four score and twenty",
      "confidence": 0.97186122,
      "words": [
        {
          "startTime": "1.300s",
          "endTime": "1.400s",
          "word": "Four"
        },
        {
          "startTime": "1.400s",
          "endTime": "1.600s",
          "word": "score"
        },
        {
          "startTime": "1.600s",
          "endTime": "1.600s",
          "word": "and"
        },
        {
          "startTime": "1.600s",
          "endTime": "1.900s",
          "word": "twenty"
        }
      ]
    }
]
""".data(using: .utf8)!

//let sampleTranscriptionList = [
//    Transcription(title: "Pacific", content: [sampleSentence]),
//    Transcription(title: "Atlantic", content: [sampleSentence]),
//    Transcription(title: "Indian", content: [sampleSentence]),
//    Transcription(title: "Southern", content: [sampleSentence]),
//    Transcription(title: "Arctic", content: [sampleSentence])
//]
