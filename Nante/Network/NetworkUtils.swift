//
//  fetch.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import Foundation

let decoder = JSONDecoder()

enum HttpMethod {
    case get
    case post
}


func fetch(
    url: URL, httpMethod: HttpMethod, apiKey: String? = nil, requestBody: [String: Any]? = nil, completion: @escaping (String?, Error?) -> Void
) {
    var request = URLRequest(url: url)
    
    switch httpMethod {
    case .get:
        request.httpMethod = "GET"
    case .post:
        request.httpMethod = "POST"
    }
    
    if let unwrappedApiKey = apiKey {
        request.addValue("Bearer \(unwrappedApiKey)", forHTTPHeaderField: "Authorization")
    }
    
    if let unwrappedRequestBody = requestBody {
        if let jsonData = try? JSONSerialization.data(withJSONObject: unwrappedRequestBody, options: .prettyPrinted) {
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil, error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
            return
        }
        
        let responseString = String(data: data, encoding: .utf8)
        completion(responseString, nil)
    }.resume()
}

func simple_fetch(url: URL, completion: @escaping (String?, Error?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        // エラーチェック
        if let error = error {
            completion(nil, error)
            return
        }
        
        guard let data = data else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
            return
        }
        
        // データをStringに変換
        if let responseString = String(data: data, encoding: .utf8) {
            completion(responseString, nil)
        } else {
            completion(nil, NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data"]))
        }
    }.resume()
}
