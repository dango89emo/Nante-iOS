//
//  Navigation.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/27.
//
import SwiftUI


struct NavigationView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(
                    #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
                )
                    .edgesIgnoringSafeArea(.all)

                HStack(spacing: 0) {
                    VStack {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "mic.fill") // マイクアイコン
                                Text("New Speech")
                            }
                            .padding()
                            .background(
                                Color(#colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1))
                            )
                            .cornerRadius(8)
                        }
                        .padding()

                        Text("HISTORY")
                            .font(.headline)
                            .padding(.top)

                        List {
                            ForEach(1...5, id: \.self) { i in
                                Text("Speech \(i)")
                            }
                        }
                    }
                    .background(Color.white)
                    .frame(width: geometry.size.width * 0.78)

                    Color.white
                        .frame(width: geometry.size.width * 0.20)
                }

                VStack {
                    Spacer()
                    TabView {
                        Image(systemName: "house.fill")
                        Image(systemName: "bell.fill")
                        Image(systemName: "person.fill")
                    }
                    .tabViewStyle(PageTabViewStyle())
                }
            }
        }
    }
}
