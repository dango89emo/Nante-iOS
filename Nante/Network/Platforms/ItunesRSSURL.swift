//
//  ItunesRSS.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/04.
//

import Foundation

struct ItunesRSSURL{
    /*
     PodCastのURLから、RSSのURLを取得する
     */
    private let URL_TEMPLATE = "https://itunes.apple.com/lookup?term=1000623463338&id=%@&media=podcast&entity=podcastEpisode&attribute=genreIndex"
    
    func makeURL(input: URL) -> URL? {
        guard let id = _idFromURL(input: input) else {
            return nil
        }
        guard let response = _lookupID(id: id) else {
            return nil
        }
        guard let feedURL = _feedURL(from: response) else {
            return nil
        }
        return URL(string: feedURL)
    }

    private func _idFromURL(input: URL) -> String? {
        /*
         Extract ID from iTunes podcast URL
         */
        let regex = try! NSRegularExpression(pattern: "/id([0-9]+)")
        let url = input.absoluteString
        let matches = regex.matches(in: url, range: NSRange(url.startIndex..., in: url))
        
        guard matches.count == 1, let range = Range(matches[0].range(at: 1), in: url) else {
            return nil
        }
        return String(url[range])
    }
    
    private func _lookupID(id: String) -> [String: Any]? {
        /*
         Looks up podcast ID in Itunes lookup service
         https://itunes.apple.com/lookup?id=<id>&entity=podcast
         :param id (String):
         :return: itunes response for the lookup as dict
         */
        let urlString = String(format: URL_TEMPLATE, id)
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        let data = try! Data(contentsOf: url) // TODO: 
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        return json
    }
    
   private func _feedURL(from itunesLookupResponse: [String: Any]) -> String? {
        guard let results = itunesLookupResponse["results"] as? [[String: Any]], results.count > 0, let url = results[1]["feedUrl"] as? String else {
            return nil
        }
        
        return url
    }
    
}


