//
//  NeonCounterLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 26/03/26.
//

import SwiftUI

struct NeonCounterLoader: View {

    // Cycle durations
    private let redDuration:   Double = 3.0   // red rings full rotation
    private let blueDuration:  Double = 4.5   // blue ring counter-rotation
    private let countDuration: Double = 4.0   // 0 → 100 counter cycle

    // Ring colours
    private let red   = Color(red: 1.00, green: 0.24, blue: 0.10)
    private let blue  = Color(red: 0.38, green: 0.28, blue: 1.00)

    var body: some View {
        ZStack {
            // Background
            Color(red: 0.06, green: 0.04, blue: 0.07).ignoresSafeArea()

            TimelineView(.animation) { tl in
                let elapsed  = tl.date.timeIntervalSinceReferenceDate
                let r1 =  (elapsed / redDuration)  * 360            // CW
                let r2 = -(elapsed / blueDuration)  * 360            // CCW
                let progress = elapsed.truncatingRemainder(dividingBy: countDuration) / countDuration
                let count    = Int(progress * 100)

                ZStack {
                    // ── Background glow ────────────────────────────────
                    RadialGradient(
                        colors: [
                            red.opacity(0.28),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 130
                    )
                    .frame(width: 260, height: 260)
                    .blur(radius: 8)

                    // ── Outer red ring ─────────────────────────────────
                    neonRing(diameter: 172, color: red, lineWidth: 2.5,
                             glowRadius: 8, rotation: r1)

                    // ── Mid red ring (slightly smaller, opposite phase) ─
                    neonRing(diameter: 156, color: red.opacity(0.85), lineWidth: 2.0,
                             glowRadius: 6, rotation: -r1 * 0.75)

                    // ── Inner red ring ─────────────────────────────────
                    neonRing(diameter: 140, color: red.opacity(0.70), lineWidth: 1.8,
                             glowRadius: 5, rotation: r1 * 1.25)

                    // ── Blue / indigo ring ─────────────────────────────
                    neonRing(diameter: 122, color: blue, lineWidth: 2.0,
                             glowRadius: 8, rotation: r2)

                    // ── Centre counter ────────────────────────────────
                    Text("\(count)")
                        .font(.system(size: 22, weight: .semibold, design: .monospaced))
                        .foregroundStyle(red)
                        .shadow(color: red.opacity(0.9), radius: 4)
                        .shadow(color: red.opacity(0.4), radius: 10)
                }
            }
        }
    }

    // MARK: – Helpers

    @ViewBuilder
    private func neonRing(diameter: CGFloat,
                          color: Color,
                          lineWidth: CGFloat,
                          glowRadius: CGFloat,
                          rotation: Double) -> some View {
        Circle()
            .stroke(color, lineWidth: lineWidth)
            .frame(width: diameter, height: diameter)
            // inner bright glow
            .shadow(color: color.opacity(0.90), radius: glowRadius * 0.5)
            // outer soft bloom
            .shadow(color: color.opacity(0.55), radius: glowRadius)
            .shadow(color: color.opacity(0.25), radius: glowRadius * 2.0)
            .rotationEffect(.degrees(rotation))
    }
}

#Preview {
    NeonCounterLoader()
}
