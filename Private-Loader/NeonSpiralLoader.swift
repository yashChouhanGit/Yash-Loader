//
//  NeonSpiralLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 17/03/26.
//

import SwiftUI

// MARK: - Neon Spiral Loader
struct NeonSpiralLoader: View {
    @State private var rotation1: Double = 0
    @State private var rotation2: Double = 0

    private let outerSize: CGFloat = 160
    private let innerSize: CGFloat = 105

    var body: some View {
        ZStack {
            Color("SpiralBackground")
                .ignoresSafeArea()

            ZStack {
                // Outer arc (~270°)
                Circle()
                    .trim(from: 0.04, to: 0.80)
                    .stroke(
                        Color("SpiralArc"),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                    )
                    .frame(width: outerSize, height: outerSize)
                    .shadow(color: Color("SpiralArc").opacity(0.9), radius: 4,  x: 0, y: 0)
                    .shadow(color: Color("SpiralArc").opacity(0.6), radius: 10, x: 0, y: 0)
                    .shadow(color: Color("SpiralArc").opacity(0.3), radius: 22, x: 0, y: 0)
                    .rotationEffect(.degrees(rotation1))

                // Inner arc (~270°) — counter-rotates
                Circle()
                    .trim(from: 0.06, to: 0.79)
                    .stroke(
                        Color("SpiralArc").opacity(0.45),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: innerSize, height: innerSize)
                    .shadow(color: Color("SpiralArc").opacity(0.5), radius: 6,  x: 0, y: 0)
                    .shadow(color: Color("SpiralArc").opacity(0.25), radius: 14, x: 0, y: 0)
                    .rotationEffect(.degrees(rotation2))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                rotation1 = 360
            }
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                rotation2 = -360
            }
        }
    }
}

#Preview {
    NeonSpiralLoader()
}
