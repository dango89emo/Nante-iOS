//
//  NanteApp.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/27.
//

import SwiftUI

@main
struct NanteApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.light)
                .environmentObject(appState)
                .environment(\.colorScheme, .light)
                .environment(\.font, Font.custom("HelveticaNeue", size: 16))
        }
    }
}

