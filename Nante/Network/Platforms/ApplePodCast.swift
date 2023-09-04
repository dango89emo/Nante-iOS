//
//  ApplePodCast.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import Foundation
import SwiftSoup


struct ApplePodCast: Platform{
    private var input: URL
    private (set) var resourceURL: URL? {
        self.resourceURL = resourceURL
    }
    private (set) var title: String?
    private (set) var publishDate: Date?
    private (set) var platformSpecificMetadata: String?
    
    mutating func parseInput(input: URL) {
        self.input = input
        
        if let htmlText = _fetchHTML() {
            title = _extractH1(htmlText)
        }

        let rssURL = _makeRSSURL()
        let RSSText = _fetchRSSFeed(url: rssURL)
        
        
        let podCast = _extractPodCast(RSSText)
    }
    
    func _fetchHTML()-> String?{
        var html_string: String
        var hasError: Bool = false
        fetch(url: self.input,httpMethod: .get) { html, error in
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
    
    func _makeRSSURL()->URL{
        
    }
    
    func _fetchRSSFeed(url: URL) -> String {
        fetch(url: url, httpMethod: .post) { (responseString, error) in
            if let jsonStr = responseString {
                if let data = jsonStr.data(using: .utf8) {
                    do {
                        let decodedObject = try JSONDecoder().decode(YourDecodableStruct.self, from: data)
                        print(decodedObject)
                    } catch {
                        print("Error decoding: \(error)")
                    }
                }
            }
        }
    }


    

    func _extractH1(_ htmlText: String)-> String{
        
    }

    func _extractPodCast(_ RSSText: String, H1: String) ->(String, String, AudioMetadata){
        
    }
    
    func getResourceURL() -> URL? {
        
    }
    func getTitle() -> String?{
        
    }
    func getPublishDate() -> Date?{
        
    }
    func getPlatformSpecificMetadata() -> String?{
        
    }

    func fetchResourceURL(input: URL) -> URL? {
        
    }
}




