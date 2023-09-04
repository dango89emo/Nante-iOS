//
//  AppState.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/27.
//
import SwiftUI

class CurrentState: ObservableObject {
    @Published var options: AppStates = []
}

struct AppStates: OptionSet{
    let rawValue: Int
    static let hasShownLogo = AppStates(rawValue: 1 << 0)
    static let hasLoggedIn = AppStates(rawValue: 1 << 1)
    static let isNewSpeech = AppStates(rawValue: 1 << 2)
    static let isPlayer = AppStates(rawValue: 1 << 3)
}
