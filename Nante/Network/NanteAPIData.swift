//
//  Data.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/02.
//

import Foundation

let nanteAPIData = NanteAPIData()

struct NanteAPIData {
    let domain: URL = URL(string: "http://192.168.11.3:8000/")!
    let apiKey: String = "aiueo"
}
