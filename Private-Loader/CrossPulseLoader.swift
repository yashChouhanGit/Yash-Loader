//
//  CrossPulseLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 26/03/26.
//

import SwiftUI

struct CrossPulseLoader: View {
    @State private var scales: [CGFloat] = [1.0, 1.0, 1.0, 1.0]
    @State private var offsets: [CGFloat] = [0.0, 0.0, 0.0, 0.0]

    private let cyan       = Color(red: 0.00, green: 0.84, blue: 0.90)
    private let centerFill = Color(red: 0.18, green: 0.18, blue: 0.19)

    private let dotSize:    CGFloat = 58
    private let centerSize: CGFloat = 72
    private let orbit:      CGFloat = 100   // distance from center to outer dot centres

    // top, right, bottom, left  (unit vectors)
    private let dirs: [(x: CGFloat, y: CGFloat)] = [
        ( 0, -1), ( 1,  0), ( 0,  1), (-1,  0)
    ]

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ZStack {
                // 4 outer cyan dots
                ForEach(0..<4, id: \.self) { i in
                    Circle()
                        .fill(cyan)
                        .frame(width: dotSize, height: dotSize)
                        .offset(
                            x: dirs[i].x * (orbit + offsets[i]),
                            y: dirs[i].y * (orbit + offsets[i])
                        )
                        .scaleEffect(scales[i])
                }

                // Dark center dot
                Circle()
                    .fill(centerFill)
                    .frame(width: centerSize, height: centerSize)
            }
        }
        .onAppear { startAnimations() }
    }

    private func startAnimations() {
        for i in 0..<4 {
            let delay = Double(i) * 0.18

            // Scale pulse: 1.0 → 1.28 → 1.0
            withAnimation(
                .easeInOut(duration: 0.72)
                .repeatForever(autoreverses: true)
                .delay(delay)
            ) {
                scales[i] = 1.28
            }

            // Slight radial push-out in sync with scale
            withAnimation(
                .easeInOut(duration: 0.72)
                .repeatForever(autoreverses: true)
                .delay(delay)
            ) {
                offsets[i] = 8
            }
        }
    }
}

#Preview {
    CrossPulseLoader()
}
