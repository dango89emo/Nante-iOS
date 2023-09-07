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
//    private let URL_TEMPLATE = "https://itunes.apple.com/lookup?term=jack+johnson&id=%@&media=podcast&entity=podcastEpisode&attribute=genreIndex&limit=200&country=JP&explicit=Yes"
    private let URL_TEMPLATE = "https://itunes.apple.com/lookup?&id=%@&media=podcast&entity=podcastEpisode&explicit=Yes&country=JP"
    func makeURL(input: URL) -> (URL, String?, Int?)? {
        guard let id = _idFromURL(input: input) else {
            return nil
        }
        guard let trackID = _trackIdFromURL(input: input) else {
            return nil
        }
        guard let response = _lookupID(id: id) else {
            return nil
        }
        guard let feedURL = _feedURL(from: response) else {
            return nil
        }
        guard let url = URL(string: feedURL) else { return nil }
        guard let (guid, duration) = guidAndDuration(from: response, targetTrackID: trackID) else { return nil }
                
        return (url, guid, duration)
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
    private func _trackIdFromURL(input: URL)->Int64?{
        guard let components = URLComponents(url: input, resolvingAgainstBaseURL: false) else { return nil}
        if let queryItem = components.queryItems?.first(where: { $0.name == "i" }) {
            if let value = queryItem.value {
                return Int64(value) // 1000625791769
            } else {return nil}
        } else {return nil}
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
       guard let results = itunesLookupResponse["results"] as? [[String: Any]] else { return nil}
       if results.count > 0 {
           let url = results[0]["feedUrl"] as? String
           return url
       }
       return nil
    }
    private func guidAndDuration(from itunesLookupResponse: [String: Any], targetTrackID: Int64) -> (String?, Int?)? {
        print("target")
        print(targetTrackID)
        guard let results = itunesLookupResponse["results"] as? [[String: Any]] else { return nil}
        print(results.count)
        if results.count > 0 {
            for result in results {
                guard let TrackID = result["trackId"] as? Int64 else {
                    print("no trackID found")
                    continue
                }
                if targetTrackID != TrackID {continue}
                return (result["episodeGuid"] as? String, result["trackTimeMillis"] as? Int)
            }
            print("no trackID Found")
        } else{print("no results found")}
        return nil
     }
}


