//
//  DotRingLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 17/03/26.
//

import SwiftUI

struct DotRingLoader: View {
    @State private var rotation: Double = 0

    private let dotCount   = 14
    private let radius: CGFloat = 62
    private let arcSpan: Double = 270   // degrees covered by the arc

    var body: some View {
        ZStack {
            Color("DotBackground")
                .ignoresSafeArea()

            ZStack {
                ForEach(0..<dotCount, id: \.self) { i in
                    // progress: 0 = tail (small/dim), 1 = head (large/bright)
                    let progress = Double(i) / Double(dotCount - 1)
                    let angle    = progress * arcSpan               // 0° … 270°
                    let size     = CGFloat(4 + progress * 14)       // 4 pt … 18 pt
                    let opacity  = 0.12 + progress * 0.88           // 0.12 … 1.0
                    let glowRadius: CGFloat = progress > 0.65 ? 10 : 0

                    Circle()
                        .fill(Color("DotGlow").opacity(opacity))
                        .frame(width: size, height: size)
                        .shadow(color: Color("DotGlow").opacity(progress > 0.65 ? 0.85 : 0),
                                radius: glowRadius, x: 0, y: 0)
                        .shadow(color: Color("DotGlow").opacity(progress > 0.80 ? 0.5 : 0),
                                radius: 20, x: 0, y: 0)
                        .offset(y: -radius)
                        .rotationEffect(.degrees(angle))
                }
            }
            .rotationEffect(.degrees(rotation))
        }
        .onAppear {
            withAnimation(.linear(duration: 1.6).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    DotRingLoader()
}
