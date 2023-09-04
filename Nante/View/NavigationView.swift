//
//  NavigationView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import SwiftUI

struct NavigationView: View {
    private let listPaddingRatio = 0.13
    @State private var singleSelection = Set<UUID>()
    @EnvironmentObject var currentState: CurrentState
    @EnvironmentObject var audioList: AudioList
    
    var body: some View {
        GeometryReader { geometry in
            Color("BaseColor")
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                
                HStack{
                    Spacer()
                    Button(action: {
                        currentState.options.insert(.isNewSpeech)}
                    ) {
                        HStack {
                            Image("NewSpeech")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("New Speech")
                                .foregroundColor(Color("BaseTextColor"))
                        }
                        .frame(width: geometry.size.width * 0.663, height: 60)
                        .background(
                            Color("FocusColor")
                        )
                    }
                    .padding(.top, 40)
                    Spacer()
                }

                if let audioItems = audioList.items {
                    HStack {
                        Text("HISTORY")
                            .foregroundColor(Color("BaseTextColor"))
                            .font(.headline)
                            .padding(.top, 30)
                            .padding(.leading, 5)
                            .padding(.bottom, 5)
                        Spacer()
                    }
                    .padding(.leading, geometry.size.width * listPaddingRatio)
                    List (audioItems, selection: $singleSelection) { audio in
                        let index = audioItems.firstIndex(of:audio)
                        let colorName = audioList.selectionIndex == index ? "FocusColor" : "BaseColor"
                          HStack {
                              Text(audio.title)
                                  .foregroundColor(Color("BaseTextColor"))
                                  .fontWeight(audioList.selectionIndex == index ? .bold: .regular)
                                  .lineLimit(2)
                                  .truncationMode(.tail)
                              Spacer()
                              ProgressIcon(progress: audio.progress, strokeWidth: 6)
                                  .scaleEffect(0.5) // サイズを半分にする
                                  .frame(width: 30, height: 30)
                          }
                          .listRowBackground(
                              Color(colorName)
                                  .frame(height: 30)
                          )
                          .onTapGesture {
                              audioList.selectionIndex = index
                              currentState.options.insert(.isPlayer)
                          }
                    }
                    // ListStyles
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .padding(.leading, geometry.size.width * listPaddingRatio)
                    .background(Color.clear)
                    .environment(\.defaultMinListRowHeight, 35)
                    
                    Spacer()
                }
            }
            .background(Color("BaseColor"))
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
