//
//  ClassicSpinnerLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 04/04/26.
//

import SwiftUI

struct ClassicSpinnerLoader: View {

    private let dotCount   = 8
    private let radius:    CGFloat = 44
    private let dotSize:   CGFloat = 16
    private let period:    Double  = 0.9   // one full rotation

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            TimelineView(.animation) { tl in
                dotsView(phase: (tl.date.timeIntervalSinceReferenceDate / period)
                    .truncatingRemainder(dividingBy: 1.0))
            }
        }
    }

    private func dotsView(phase: Double) -> some View {
        ZStack {
            ForEach((0..<8), id: \.self) { i in
                let angle      = Double(i) / Double(dotCount) * 2 * .pi
                let x          = radius * CGFloat(cos(angle - .pi / 2))
                let y          = radius * CGFloat(sin(angle - .pi / 2))
                let slotPhase  = Double(i) / Double(dotCount)
                let diff       = (slotPhase - phase + 1.0).truncatingRemainder(dividingBy: 1.0)
                let brightness = diff < 0.5
                    ? 1.0 - diff * 1.6
                    : max(0.05, 0.2 - (diff - 0.5) * 0.3)

                Circle()
                    .fill(Color.white.opacity(brightness))
                    .frame(width: dotSize, height: dotSize)
                    .offset(x: x, y: y)
            }
        }
    }
}

#Preview {
    ClassicSpinnerLoader()
}
