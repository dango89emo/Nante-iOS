//
//  ProgressBar.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/04.
//

import SwiftUI

struct ProgressBar: View {
    @ObservedObject var progress: ProgressModel
    
    var body: some View {
        ProgressView(value: progress.value, total: 1.0)
            .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        var progress = ProgressModel(0.5)
        ProgressBar(progress: progress)
    }
}
