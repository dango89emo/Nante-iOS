//
//  ContentView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/31.
//

import SwiftUI

struct ContentView: View {
    init() {
        // タブバーの背景色を設定する
        let appearance = UITabBarAppearance()
        appearance.backgroundColor =  UIColor(Color("BaseColor"))
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            NavigationView()
                .tabItem {
                    (Label{
                        Text("Home")
                        } icon: {
                            Image("BlackAppIcon")
                        }
                    ).labelStyle(.iconOnly)
                }
            SearchView()
                .tabItem {
                    (Label{
                        Text("Search")
                        } icon: {
                            Image("SearchIcon")
                        })
                    .labelStyle(.iconOnly)
                }
            
            SettingsView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                    .labelStyle(.iconOnly)
                }
        }
    }
}


