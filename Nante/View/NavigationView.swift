//
//  NavigationView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import SwiftUI

struct NavigationView: View {
    @State private var singleSelection = Set<UUID>()
    @EnvironmentObject var currentState: CurrentState
    @EnvironmentObject var transcriptionList: TranscriptionList
    
    var body: some View {
        GeometryReader { geometry in
            Color("NavigationBackgroundColor")
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0){
                Spacer()
                // Navigation Panel
                VStack(spacing: 0) {
                    Button(action: {currentState.options.insert(.isNewSpeech)}) {
                        HStack {
                            Image("NewSpeech")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("New Speech")
                                .foregroundColor(Color("BaseTextColor"))
                        }
                        .frame(width: geometry.size.width * 0.663, height: 40)
                        .background(
                            Color("FocusColor")
                        )
                    }
                    .padding(.top, 40)
                    
                    HStack {
                        Text("HISTORY")
                            .foregroundColor(Color("BaseTextColor"))
                            .font(.headline)
                            .padding(.top, 30)
                            .padding(.leading, 5)
                            .padding(.bottom, 5)
                        Spacer()
                    }
                    
                    List (transcriptionList.items, selection: $singleSelection) { transcription in
                        let index = transcriptionList.items.firstIndex(of:transcription)
                        let colorName = selectionIndex == index ? "FocusColor" : "BaseColor"
                        HStack {
                            Text(transcription.title)
                                .foregroundColor(Color("BaseTextColor"))
                                .fontWeight(selectionIndex == index ? .bold: .regular)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Spacer()
                            ProgressIcon(progress: transcription.progress, strokeWidth: 6)
                                .scaleEffect(0.5) // サイズを半分にする
                                .frame(width: 30, height: 30)
                        }
                        .listRowBackground(
                            Color(colorName)
                                .frame(height: 30)
                        )
                        .onTapGesture {selectionIndex = index}
                        
                    }
                    // ListStyles
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .padding(.leading, 10)
                    .background(Color.clear)
                    .environment(\.defaultMinListRowHeight, 35)
                }
                // Navigation Panel Style
                .padding(.horizontal, 20)
                .background(Color("BaseColor"))
            } // VStack
            .frame(height: geometry.size.height)
        }
    }
}

extension UICollectionReusableView {
    override open var backgroundColor: UIColor? {
        get { .clear }
        set { }
    }
}
//struct NavigationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView()
//    }
//}
