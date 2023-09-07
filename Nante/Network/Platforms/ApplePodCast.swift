//
//  ApplePodCast.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import Foundation
import SwiftSoup


struct ApplePodCast: Platform{
    private (set) var input: URL = URL(string: "text")!
    private (set) var title: String?
    private (set) var resourceURL: URL?
    private (set) var duration: Double?
    private (set) var platformSpecificMetadata: String?
    let itunesRSS = ItunesRSSURL()
    
    mutating func parseInput(input: URL) {
        self.input = input
        
        if let htmlText = String(data: try! Data(contentsOf: input), encoding: .utf8){
            if let h1 = extractH1(htmlText){
                self.title = h1
            }
        }
        guard let HTMLString = String(data: try! Data(contentsOf: self.input), encoding: .utf8) else {return }
        guard let assetURL = extractAssetUrl(from: HTMLString) else { return }
        
        self.resourceURL = URL(string: decodeUnicodeEscape(assetURL))!
        
        guard let (rssURL, GUID, _) = itunesRSS.makeURL(input: self.input) else {
            return
        }
//        if let duration = duration { self.duration = Double(duration) }
        guard let RSSFeed = String(data: try! Data(contentsOf: rssURL), encoding: .utf8) else { return }
            //            guard let RSSFeed = fetchRSSFeed(url: rssURL) else {
            //                return
            //            }
        parseRSSFeed(RSSFeed, GUID: GUID)
    }
    
    private func fetchHTML()-> String?{
        var html_string: String?
        var hasError: Bool = false
        simple_fetch(url: self.input) { html, error in
        if let e = error {
                hasError = true
            } else if let h = html {
                html_string = h
            }
        }
        if hasError {
            return nil
        }
        return html_string
    }
    
    private func extractH1(_ htmlText: String)-> String?{
        do {
            let doc: Document = try SwiftSoup.parse(htmlText)
            let h1: Element = try doc.select("h1").first()!
            let h1_string: String = try h1.text()
            return h1_string
        } catch {
            return nil
        }
    }
    private func fetchRSSFeed(url: URL) -> String? {
        var xml_string: String?
        var hasError: Bool = false
        simple_fetch(url: url) { xml, error in
            if let e = error {
                hasError = true
            } else if let xml = xml {
                xml_string = xml
            }
        }
        if hasError {
            return nil
        }
        return xml_string
    }
    
        mutating private func parseRSSFeed(_ rssFeed: String, GUID: String?){

        guard let doc = try? SwiftSoup.parse(rssFeed, "", Parser.xmlParser()) else { return }
        guard let items: Elements = try? doc.getElementsByTag("item") else { return } // 各エピソード
        guard let h1Title = self.title else { return }

        for item: Element in items.array(){
            guard let xmlTitle:String = getXMLElementString(xmlElement: item, tagName: "title") else { return }

            var isGuidSame: Bool = false
            if let guid = GUID, let xmlGUID:String = getXMLElementString(xmlElement: item, tagName: "guid") {
               isGuidSame = guid == xmlGUID
            }
            /*isMatching(h1Title, xmlTitle, matchLength: 10)||<=タイトルが大部分共通しているタイプのチャンネルでは危険*/
            if !(isGuidSame||(h1Title.contains(xmlTitle) || xmlTitle.contains(h1Title))){
                continue
            }
            // url文字列を取得
            guard let resourceURLString = getXMLAttributeString(xmlElement: item, tagName: "enclosure", attrName: "url") else { return }
            // URL形式に変換
            guard let url = URL(string: resourceURLString) else { return }
            self.resourceURL = url
            
//            // 発行日の文字列を取得
//            guard let publishDateString = getXMLElementString(xmlElement: item, tagName: "pubDate") else { return }
//
//            // Date形式に変換
//            guard let publishDate = dateFromString(publishDateString) else { return }
//            self.publishDate = publishDate
            
            // durationの文字列を取得
            guard let durationString = getXMLElementString(xmlElement: item, tagName: "itunes|duration") else { return }
            
            // TimeIntervalに変換
            guard let duration = timeInterval(from: durationString) else {return}
            self.duration = duration
            break
        }

        // チャンネル名を取得
        // channelタグの中のtitleダグを参照
        guard let channnelTitle = getXMLElementStringByCSSSelector(xml: doc, cssSelector: "channel > title") else { return }
        self.platformSpecificMetadata = channnelTitle
    }
    
    private func isMatching(_ str1: String, _ str2: String, matchLength: Int) -> Bool {
        let length1 = str1.count
        let length2 = str2.count
        
        var dp = [[Int]](repeating: [Int](repeating: 0, count: length2 + 1), count: length1 + 1)
        var maxLength = 0

        for i in 1...length1 {
            for j in 1...length2 {
                if str1[str1.index(str1.startIndex, offsetBy: i-1)] == str2[str2.index(str2.startIndex, offsetBy: j-1)] {
                    dp[i][j] = dp[i-1][j-1] + 1
                    maxLength = max(maxLength, dp[i][j])
                }
            }
        }

        return maxLength >= matchLength
    }
    
    
    private func getXMLElementStringByCSSSelector(xml:Document, cssSelector:String)->String?{
        guard let element:Element = try? xml.select(cssSelector).first() else {
            return nil
        }
        let elementString = try? element.text()
        return elementString
    }
    
    private func getXMLElementString(xmlElement:Element, tagName:String)->String?{
        guard let element:Element = try? xmlElement.select(tagName).first() else {
            return nil
        }
        let elementString = try? element.text()
        return elementString
    }
    
    private func getXMLAttributeString(xmlElement: Element, tagName: String, attrName: String)->String?{
        guard let element:Element = try? xmlElement.select(tagName).first() else {
            return nil
        }
        let attrString = try? element.attr(attrName)
        return attrString
    }
    
    private func timeInterval(from timeString: String) -> TimeInterval? {
        // 単純な秒数の場合
        if let simpleSeconds = Double(timeString) {
            return simpleSeconds
        }
        
        let timeParts = timeString.split(separator: ":").compactMap { Double($0) }
        
        // mm:ss の形式の場合
        if timeParts.count == 2 {
            let minutesToSeconds = timeParts[0] * 60
            let seconds = timeParts[1]
            return minutesToSeconds + seconds
        }
        
        // HH:mm:ss の形式の場合
        if timeParts.count == 3 {
            let hoursToSeconds = timeParts[0] * 3600
            let minutesToSeconds = timeParts[1] * 60
            let seconds = timeParts[2]
            return hoursToSeconds + minutesToSeconds + seconds
        }
        return nil
    }

    private func extractAssetUrl(from string: String) -> String? {
        // 正規表現を使って assetUrl の値を取得
        let pattern = #"assetUrl\\":\\\"(.*?)\\\"\}"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])

        if let match = regex?.firstMatch(in: string, options: [], range: NSRange(string.startIndex..., in: string)) {
            if let range = Range(match.range(at: 1), in: string) {  // match.range(at: 1) はキャプチャしたサブストリングの範囲
                return String(string[range])
            }
        }
        
        return nil
    }
    private func decodeUnicodeEscape(_ string: String) -> String {
        let pattern = "\\\\u(....)"  // \uと4つの文字をキャプチャ
        let regex = try? NSRegularExpression(pattern: pattern, options: [])

        var result = string
        if let matches = regex?.matches(in: string, options: [], range: NSRange(string.startIndex..., in: string)) {
            for match in matches.reversed() {  // reversed() で後ろから処理
                let range = match.range(at: 1)
                if let hexRange = Range(range, in: string) {
                    let hexString = String(string[hexRange])
                    if let scalarValue = UInt32(hexString, radix: 16),
                       let unicodeScalar = UnicodeScalar(scalarValue) {
                        let char = String(unicodeScalar)
                        result = result.replacingOccurrences(of: "\\u\(hexString)", with: char)
                    }
                }
            }
        }

        return result
    }

}

