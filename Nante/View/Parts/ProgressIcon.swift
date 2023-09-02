//
//  ProgressIcon.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/01.
//

import SwiftUI


struct ProgressIcon: View {
    @ObservedObject var progress: ProgressModel
    var strokeWidth: CGFloat

    var body: some View {
        ProgressView(value: progress.value, total: 1.0)
            .progressViewStyle(GaugeProgressStyle(strokeWidth: strokeWidth))
            .contentShape(Rectangle())
    }
}

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color.accentColor
    var strokeWidth: CGFloat
    
    init(strokeWidth: CGFloat){
        self.strokeWidth = strokeWidth
    }
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .stroke(Color.gray, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}
