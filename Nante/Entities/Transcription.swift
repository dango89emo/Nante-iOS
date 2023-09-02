//
//  Transcription.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/01.
//

import Foundation

class ProgressModel: ObservableObject {
    @Published var value: Float = 0.0
}

class Transcription: Identifiable, Equatable, ObservableObject {
    var title: String
    let id = UUID()
    var content: String = "Southern Southern Southern Southern Southern Southern Southern Southern Southern"
    var progress: ProgressModel
    init(title: String){
        self.title = title
        self.progress = ProgressModel()
    }
    static func == (lhs: Transcription, rhs: Transcription) -> Bool {
            return lhs.id == rhs.id
        }
}

class TranscriptionList: ObservableObject{
    @Published var items = [
        Transcription(title: "Pacific"),
        Transcription(title: "Atlantic"),
        Transcription(title: "Indian"),
        Transcription(title: "Southern"),
        Transcription(title: "Arctic")
    ]
}
