//
//  Navigation.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/08/27.
//
import SwiftUI


struct Ocean: Identifiable, Hashable {
    let name: String
    let id = UUID()
}


private var oceans = [
    Ocean(name: "Pacific"),
    Ocean(name: "Atlantic"),
    Ocean(name: "Indian"),
    Ocean(name: "Southern"),
    Ocean(name: "Arctic")
]


struct NavigationView: View {
    @State private var singleSelection = Set<UUID>()
    init(){
        UITableView.appearance().backgroundColor = UIColor(Color("BaseColor"))
    }

    var body: some View {
        GeometryReader { geometry in
            let statusBarHeight = geometry.safeAreaInsets.top

            ZStack {
                Color("NavigationBackgroundColor")
                    .edgesIgnoringSafeArea(.all)

                HStack{

                    Spacer()

                    // Navigation Panel
                    VStack {
                        Button(action: {}) {
                            HStack {
                                Image("NewSpeech")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("New Speech")
                                    
                            }
                            .frame(width: geometry.size.width * 0.78, height: 30)
                            .background(
                                Color("FocusColor")
                            )
                        }
                        .padding()

                        Text("HISTORY")
                            .foregroundColor(Color("BaseTextColor"))
                            .font(.headline)
                            .padding(.top)

                        List (oceans, selection: $singleSelection) { ocean in
                            HStack {
                                Text(ocean.name)
                                    .listRowBackground(Color("BaseColor"))
                            }
                        }
                    }
                    .background(Color.white)
                    .frame(
                        width: geometry.size.width * 0.78,
                        height: geometry.size.height // - statusBarHeight
                    )

                    // Player Panel
                    Color.white
                        .frame(
                            width: geometry.size.width * 0.20,
                            height: geometry.size.height // - statusBarHeight
                        )
                }
            }
        }
    }
}
