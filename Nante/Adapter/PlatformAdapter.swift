//
//  Platform.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import Foundation

protocol Platform{
    var resourceURL: URL? {get}
    var title: String? {get}
//    var publishDate: Date? {get}
    var duration: TimeInterval? {get}
    var platformSpecificMetadata: String? {get}
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
    
    func makeAudioSpecifier() -> Result<AudioSpecifier, TranscriptionError>{
        guard let resourceURL = self.platform?.resourceURL else {
            return .failure(.resourceNotFound)
        }
        guard let title = self.platform?.title else {
            return .failure(.titleNotFoundError)
        }
//        guard let publishDate = self.platform?.publishDate else {
//            return nil
//        }
        let duration = self.platform?.duration
        guard let duration = self.platform?.duration else {
            return .failure(.durationConversionError)
        }
        let platformSpecificMetadata = self.platform?.platformSpecificMetadata
        
        return .success(AudioSpecifier(
            resourceURL: resourceURL, title: title, /*publishDate: publishDate,*/ duration: duration, platformSpecificMetadata: platformSpecificMetadata
        ))
    }
}




