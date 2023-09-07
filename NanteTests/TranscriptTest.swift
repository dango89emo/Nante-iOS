//
//  TranscriptTest.swift
//  NanteTests
//
//  Created by 谷内洋介 on 2023/09/03.
//

import XCTest
import SwiftSoup
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
    
    func testCanReadAndDecodeLocalTranscription() throws {
        
       guard let url = Bundle.main.url(forResource: "sampleTranscription", withExtension: "json") else {
           fatalError("ファイルが見つからない")
       }
        
       guard let data = try? Data(contentsOf: url) else {
           fatalError("ファイル読み込みエラー")
       }
        
       let decoder = JSONDecoder()
       guard let sentences = try? decoder.decode([Sentence].self, from: data) else {
           fatalError("JSON読み込みエラー")
       }
       XCTAssertEqual(sentences[0].transcript,"test test test mic 1 Kelsey's Mike how we doing here sounds good alright good oh my God Zach are you okay man yeah I'm concerned cuz this is a 12 pack of white claw in your you made a pretty good done how many of you had")
    }
    
    func testGetRSSFeedAndTrackID() throws {
        
       let inputs = [
         "https://podcasts.apple.com/jp/podcast/the-tiny-meat-gang-podcast/id1303668524?i=1000625791769",
         "https://podcasts.apple.com/jp/podcast/the-tiny-meat-gang-podcast/id1303668524?i=1000625474723",
         "https://podcasts.apple.com/jp/podcast/deutsch-warum-nicht-series-3-learning-german-deutsche/id268481782?i=1000457334245",
         "https://podcasts.apple.com/jp/podcast/%E3%82%B1%E3%83%93%E3%83%B3%E3%81%AFa%E5%9E%8B%E3%81%AA%E3%82%93%E3%81%98%E3%82%83%E3%81%AA%E3%81%84%E3%81%8B-%E3%81%A8%E6%80%9D%E3%81%86%E7%9E%AC%E9%96%93/id1518322346?i=1000626786600",
          "https://podcasts.apple.com/jp/podcast/people-of-ai/id1676344240?i=1000613547939",
        "https://podcasts.apple.com/jp/podcast/people-of-ai/id1676344240?i=1000605590945"
         // 以下、iTunes APIに公開されていなかったり、最新200件には届いていないため、サーチできないPodCast
//         "https://podcasts.apple.com/jp/podcast/english-news-nhk-world-radio-japan/id141016660?i=1000625895411",
//         "https://podcasts.apple.com/jp/podcast/discovery/id284012446?i=1000413014797",
//         "https://podcasts.apple.com/jp/podcast/american-english-pronunciation-podcast/id276921054?i=1000381718980",
//         "https://podcasts.apple.com/jp/podcast/philosophy-bites/id257042117?i=1000388596742"
       ]
        for input in inputs{
            let url = URL(string: input)!
            let i = ItunesRSSURL()
            let res = i.makeURL(input: url)
            XCTAssertNotNil(res)
        }
    }
}


