//
//  Navigation.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/27.
//
import SwiftUI
import Foundation

struct NavigationView: View {
    @State private var singleSelection = Set<UUID>()
    @State var selectionIndex: Int? =  nil
    @State private var isNewSpeech: Bool = false
    @ObservedObject var urlText = ResourceURLModel()
    @ObservedObject var transcriptionList = TranscriptionList()
    
    var body: some View {
        GeometryReader { geometry in

            ZStack {
                if isNewSpeech {
                    // New Speach View
                    Color("BaseColor")
                    VStack(spacing: 0) {
                        ZStack {
                            HStack{
                                ZStack{
                                    HStack{
                                        Color.accentColor
                                            .frame(width: 36, height: 52)
                                            .padding()
                                        Spacer()
                                    }
                                    HStack{
                                        Image(systemName: "link")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding()
                                            .background(Color.accentColor)
                                            .foregroundColor(.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        Spacer()
                                    }
                                    
                                }
                                Spacer()
                            }
                            TextField("Enter URL here...", text: $urlText.value)
                                .padding()
                                .textContentType(.none)
                                .padding(.leading, 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        .padding(.bottom, 20)
                        
                        Button("Import") {
                            // ここにImportボタンをクリックした時の処理を書く
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                    .padding()
                    
                } else {
                    Color("NavigationBackgroundColor")
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 0){
                        Spacer()
                        HStack {
                            // Navigation Panel
                            VStack(spacing: 0) {
                                Button(action: {isNewSpeech = true}) {
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
                            
                            if let unwrappedIndex = selectionIndex{
                                // Player Panel
                                Spacer()
                                    .frame(width: 30)
                                
                                VStack{
                                    
                                    Text(transcriptionList.items[unwrappedIndex].content)
                                        .padding(30)
                                    
                                }
                                .frame(
                                    width: geometry.size.width,
                                    height: geometry.size.height
                                )
                                .background(Color("BaseColor"))
                            } //else {
                            // Voice Interface Panel
                            // }
                        } // HStack
                    } // VStack
                    .frame(height: geometry.size.height)
                }
            }
        }
    }
}

extension UICollectionReusableView {
    override open var backgroundColor: UIColor? {
        get { .clear }
        set { }
    }
}
