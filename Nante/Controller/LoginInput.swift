//
//  SwiftUIView.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/07.
//

import SwiftUI

class LoginInput: ObservableObject {
    @Published var name: String = ""
    @Published var password: String = ""
}
