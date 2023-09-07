//
//  LoginView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var currentState: CurrentState
    @EnvironmentObject var user: User
    @ObservedObject var loginInput = LoginInput()
    @State private var errorMessage: String? = nil
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                TextField("Name", text: $loginInput.name)
                    .padding()
                    .textContentType(.none)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(height:52)
                    )
                TextField("Password", text: $loginInput.password)
                    .padding()
                    .textContentType(.none)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(height:52)
                    )
                Button("Login") {
                    if(loginInput.password == "sample"){
                        currentState.options.insert(.hasLoggedIn)
                        user.name = loginInput.name
                    } else{
                        errorMessage = "パスワードが間違っています！"
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(20)
                
            
                Spacer()
            }.padding(.horizontal, geometry.size.width * 0.1)

            if let errorMessage = errorMessage{
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .offset(y: 110)
                        Spacer()
                    }.padding(.horizontal, geometry.size.width * 0.1)
                    Spacer()
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
