//
//  Platform.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import Foundation

protocol Platform{
    var resourceURL: URL? {get set}
    var title: String? {get set}
    var publishDate: Date? {get set}
    var platformSpecificMetadata: String? {get set}
    mutating func parseInput(input: URL)
}

protocol Selector{
    func select(host: String) -> Platform?
}

struct PlatformAdapter{
    var platform: Platform?
    var platformSelector = PlatformSelector()
    
    mutating func judge(host: String)->Bool{
        guard let platform = platformSelector.select(host: host) else {
            return false
        }
        self.platform = platform
        return true
    }
    
    mutating func setInput(input: URL){
        self.platform?.parseInput(input: input)
    }
    
    func makeAudioSpecifier() -> AudioSpecifier?{
        guard let resourceURL = self.platform?.resourceURL else {
            return nil
        }
        guard let title = self.platform?.title else {
            return nil
        }
        guard let publishDate = self.platform?.publishDate else {
            return nil
        }
        guard let platformSpecificMetadata = self.platform?.platformSpecificMetadata else {
            return nil
        }
        
        return AudioSpecifier(
            resourceURL: resourceURL, title: title, publishDate: publishDate, platformSpecificMetadata: platformSpecificMetadata
        )
    }
}




