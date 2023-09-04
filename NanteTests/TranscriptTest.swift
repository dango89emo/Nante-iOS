//
//  TranscriptTest.swift
//  NanteTests
//
//  Created by 谷内洋介 on 2023/09/03.
//

import XCTest
@testable import Nante

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



final class TranscriptTest: XCTestCase {

    func testCanDecodeAPIResponse() throws {
        let decoder = JSONDecoder()
        let content = try decoder.decode([Sentence].self, from: samplePayload)
        XCTAssertEqual(content.count, 1)
        XCTAssertEqual(content[0].transcript, "Four score and twenty")
        XCTAssertEqual(content[0].words.count, 4)
        XCTAssertEqual(content[0].words[2].word, "and")
    }
}
