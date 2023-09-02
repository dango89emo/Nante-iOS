//
//  NewTranscriptionViewModel.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/02.
//


import SwiftUI


class NewTranscriptionViewModel: ObservableObject {
    @Published var urlText: String = ""

    func processURL() -> (url: String, metadata: AudioMetadata) {
        // ここにurlTextの処理ロジックを記述します。
        let processedURL = "https://example.com/processed.mp3" // 仮のURL
        let metadata = AudioMetadata(title: "Example Title", duration: 300)
        return (processedURL, metadata)
    }

    func callExternalAPI(url: String, metadata: AudioMetadata) {
        // APIのURLをセットアップします
        guard let apiURL = URL(string: "https://api.example.com/endpoint") else { return }

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "Authorization")

        // JSONとしてのリクエストボディをセットアップします
        let requestBody: [String: Any] = [
            "audioURL": url,
            "title": metadata.title,
            "duration": metadata.duration
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted) {
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        // リクエストを実行します
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
        }.resume()
    }
}

struct NewTranscriptionViewModel_Previews: PreviewProvider {
    static var previews: some View {
        NewTranscriptionViewModel()
    }
}
