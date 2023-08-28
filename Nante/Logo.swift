//
//  Logo.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/27.
//
import SwiftUI

struct LogoView: View {
    @EnvironmentObject var appState: AppState
    @State private var logoOpacity = 1.0

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            Image(systemName: "mic.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .opacity(logoOpacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 1.0)) {
                        logoOpacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        appState.hasShownLogo = true
                    }
                }
        }
    }
}