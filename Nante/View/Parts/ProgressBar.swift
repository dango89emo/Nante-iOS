//
//  ProgressBar.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/04.
//

import SwiftUI

struct ProgressGauge: View{
    @ObservedObject var progress: ProgressModel
    var body: some View{
        Text("\(Int(progress.value * 100))%")
            .padding(.leading, 10)
    }
}

struct ProgressBar: View {
    @ObservedObject var progress: ProgressModel
    
    var body: some View {
        ProgressView(value: progress.value, total: 1.0)
            .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
    }
}
/*struct ProgressTapView: View {
    @ObservedObject var progress: ProgressModel
    
    var body: some View {
        VStack {
            ProgressView(value: progress.value, total:1.0 )
                .overlay(
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.clear)
                            .onTapGesture(let tap = TapGesture()
                                .onEnded { gestureValue in
                                    setProgress(for: gestureValue.location, in: geometry.size)
                                }
                            return tap)
                    }
                )
            Spacer()
        }
        .padding()
    }
    
    func setProgress(for location: CGPoint, in size: CGSize) {
        let tappedProgress = Double(location.x / size.width)
        progress.value = max(0, min(1, tappedProgress)) // Ensure progress is between 0 and 1
    }
}*/



struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        var progress = ProgressModel(0.5)
        ProgressBar(progress: progress)
    }
}
