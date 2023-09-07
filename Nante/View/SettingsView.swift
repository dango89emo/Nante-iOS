//
//  SettingsView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/31.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var currentState: CurrentState
    
    var body: some View {
        ZStack {
            Color("BaseColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                if let name = user.name {
                    Text("Logged in as \(name)")
                }
                Button("Logout") {
                    currentState.options.remove(.hasLoggedIn)
                    user.name = nil
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
            }
        }
    }
}
