//
//  PulseGridLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 28/03/26.
//

import SwiftUI

struct PulseGridLoader: View {

    // Grid
    private let cols       = 9
    private let rows       = 9
    private let cellSize: CGFloat = 46   // fixed cell box per dot (controls spacing)
    private let maxDot:   CGFloat = 42   // largest dot (center, at peak)
    private let minDot:   CGFloat = 2    // smallest dot (corner, at trough)

    // Wave
    private let cycleDuration = 1.6
    private let waveK: Double = 4.2     // spatial frequency: higher = tighter wave

    // Colour
    private let blue = Color(red: 0.06, green: 0.22, blue: 1.00)

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TimelineView(.animation) { tl in
                let t = tl.date.timeIntervalSinceReferenceDate / cycleDuration

                let halfC = Double(cols - 1) / 2
                let halfR = Double(rows - 1) / 2
                let maxDist = sqrt(halfC * halfC + halfR * halfR)

                VStack(spacing: 0) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<cols, id: \.self) { col in
                                let di = Double(row) - halfR
                                let dj = Double(col) - halfC
                                let dist = sqrt(di * di + dj * dj) / maxDist  // 0…1

                                // Outward-propagating sine wave
                                let phase = 2 * Double.pi * t - dist * waveK
                                let wave  = (sin(phase) + 1.0) / 2.0           // 0…1
                                let size  = minDot + CGFloat(wave) * (maxDot - minDot)

                                Circle()
                                    .fill(blue.opacity(0.15 + 0.85 * Double(wave)))
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
    PulseGridLoader()
}
