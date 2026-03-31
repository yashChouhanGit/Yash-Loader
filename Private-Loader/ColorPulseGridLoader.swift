//
//  ColorPulseGridLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 29/03/26.
//

import SwiftUI

struct ColorPulseGridLoader: View {

    private let cols       = 9
    private let rows       = 9
    private let cellSize: CGFloat = 46
    private let maxDot:   CGFloat = 42
    private let minDot:   CGFloat = 2

    private let cycleDuration = 1.6
    private let waveK: Double  = 4.2

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TimelineView(.animation) { tl in
                let t = tl.date.timeIntervalSinceReferenceDate / cycleDuration

                let halfC   = Double(cols - 1) / 2
                let halfR   = Double(rows - 1) / 2
                let maxDist = sqrt(halfC * halfC + halfR * halfR)

                VStack(spacing: 0) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<cols, id: \.self) { col in
                                let di   = Double(row) - halfR
                                let dj   = Double(col) - halfC
                                let dist = sqrt(di * di + dj * dj) / maxDist

                                // Hue from angular position around center → full colour wheel
                                let angle = atan2(di, dj)                          // –π … π
                                let hue   = (angle / (2 * Double.pi) + 0.5)        // 0 … 1

                                // Outward-propagating sine wave (same as PulseGridLoader)
                                let phase = 2 * Double.pi * t - dist * waveK
                                let wave  = (sin(phase) + 1.0) / 2.0

                                let size  = minDot + CGFloat(wave) * (maxDot - minDot)
                                let color = Color(hue: hue, saturation: 1.0, brightness: 1.0)

                                Circle()
                                    .fill(color.opacity(0.15 + 0.85 * Double(wave)))
                                    .frame(width: size, height: size)
                                    .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ColorPulseGridLoader()
}
