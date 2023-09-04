//
//  ContentView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/31.
//

import SwiftUI


struct TabSelectionView: View {
    init() {
        // タブバーの背景色を設定する
        let appearance = UITabBarAppearance()
        appearance.backgroundColor =  UIColor(Color("BaseColor"))
        appearance.shadowColor = UIColor(Color("BaseColor"))
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    @EnvironmentObject var currentState: CurrentState
    @EnvironmentObject var audioList: AudioList
    
    var body: some View {
        TabView {
            ZStack {
                NavigationView()
                    .environmentObject(audioList)
                    .environmentObject(currentState)
                if currentState.options.contains(.isNewSpeech){
                    NewSpeechView()
                        .environmentObject(audioList)
                        .environmentObject(currentState)
                } else if(currentState.options.contains(.isPlayer)){
                    AudioPlayerView()
                        .environmentObject(audioList)
                        .environmentObject(currentState)
                }
            }
            .tabItem {Image("BlackAppIcon")}
            
            SearchView()
                .tabItem {
                    Image("SearchIcon")
                }
            
            SettingsView()
                .tabItem {
                    Image("SearchIcon")
                }
        }
    }
}


