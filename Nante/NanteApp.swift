//
//  NanteApp.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/27.
//

import SwiftUI

@main
struct NanteApp: App {
    var currentState = CurrentState()
    var audioList = AudioList()
    var user = User()

    var body: some Scene {
        let audioPlayer = AudioPlayer(audioList: audioList)
        WindowGroup {
            MainView(audioPlayer: audioPlayer)
                .preferredColorScheme(.light)
                .environmentObject(currentState)
                .environmentObject(audioList)
                .environmentObject(user)
                .environment(\.colorScheme, .light)
                .environment(\.font, Font.custom("HelveticaNeue", size: 16))
        }
    }
}

