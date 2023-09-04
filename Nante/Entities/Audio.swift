//
//  Audio.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import Foundation


class ProgressModel: ObservableObject {
    @Published var value: Double = 0.0
    init(_ value: Double){
        self.value = value
    }
    init(){}
}

// 仮の音源メタデータの構造体
class Audio: Identifiable, Equatable, ObservableObject {
    let id = UUID()
    let title: String
    let resourceURL: URL
    let publishDate: Date
    let duration: TimeInterval
    let platformSpecificMetadata: String
    @Published var transcription: Transcription?
    var progress = ProgressModel()
    init(_ resourceURL: URL, _ title: String, _ publishDate: Date, _ duration: TimeInterval, _ platformSpecificMetadata: String){
        self.resourceURL = resourceURL
        self.title = title
        self.publishDate = publishDate
        self.duration = duration
        self.platformSpecificMetadata = platformSpecificMetadata
    }
    static func == (leftHandSide: Audio, rightHandSide: Audio) -> Bool {
            return leftHandSide.id == rightHandSide.id
    }
}

class AudioList: ObservableObject {
    @Published var items: [Audio]? = nil
    @Published var selectionIndex: Int? = nil
    func insert(_ audio: Audio){
        if var unwrappedItems = items {
            unwrappedItems.insert(audio, at:0)
            items = unwrappedItems
        } else {
            // FirstSpeech
            items = [audio]
        }
    }
    func insertTranscription(transcription: Transcription){
        if let firstAudio = items?.first {
            firstAudio.transcription = transcription
            // もし再描画がうまく行かない場合、強制的にitemsを再代入して変更を通知する
            items = items
        }
    }
}
