//
//  Navigation.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/27.
//
import SwiftUI
import Foundation

struct ContentsView: View {
    @EnvironmentObject var currentState: CurrentState
    @EnvironmentObject var audioList: AudioList
    
    var body: some View {
        Group {
            if currentState.options.contains(.isNewSpeech){
                NewSpeechView()
            } else if(currentState.options.contains(.isPlayer)){
                AudioPlayerView()
            } else {
                NavigationView()
            }
        }
    }
}



//struct NavigationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView()
//    }
//}
