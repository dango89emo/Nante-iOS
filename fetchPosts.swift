#!/usr/bin/swift

import Foundation

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
let semaphore = DispatchSemaphore(value: 0)

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

// let task = URLSession.shared.dataTask(with: url) { data, response, error in
let task = URLSession.shared.dataTask(with: url) { data, response, error in
    defer { semaphore.signal() }  // タスクが終了したらs
    
    // エラーハンドリング
    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    
    // データの存在確認
    guard let data = data else {
        print("No data received from server")
        return
    }
    
    // データのデコード
    do {
        let posts = try JSONDecoder().decode([Post].self, from: data)
        // 最初の投稿のタイトルを表示
        if let firstPost = posts.first {
            print(firstPost.title)
            print(firstPost.body)
        }
    } catch let decodeError {
        print("Decoding error: \(decodeError.localizedDescription)")
    }
}

task.resume()
semaphore.wait()
