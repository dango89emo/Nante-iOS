//
//  MainView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/27.
//
import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.hasShownLogo {
                ContentView()
            } else {
                LogoView()
            }
        }
    }
}

