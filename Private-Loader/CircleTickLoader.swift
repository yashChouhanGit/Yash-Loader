//
//  CircleTickLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 25/03/26.
//

import SwiftUI

struct CircleTickLoader: View {

    // MARK: – Constants
    private let accentColor  = Color(red: 0.22, green: 0.93, blue: 0.83)  // bright cyan-teal
    private let dimColor     = Color(red: 0.22, green: 0.42, blue: 0.40)  // muted teal-gray
    private let tickCount    = 48
    private let tickWidth:   CGFloat = 4
    private let tickHeight:  CGFloat = 18
    private let tickRadius:  CGFloat = 98   // offset from center
    private let arcDiameter: CGFloat = 152  // arc sits just inside ticks
    private let duration:    Double  = 3.5  // seconds per 0→100% cycle

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed  = timeline.date.timeIntervalSinceReferenceDate
            let progress = CGFloat(elapsed.truncatingRemainder(dividingBy: duration) / duration)

            ZStack {
                Color.black.ignoresSafeArea()

                ZStack {
                    // ── Tick ring ─────────────────────────────────────
                    ForEach(0..<tickCount, id: \.self) { i in
                        tickView(index: i, progress: progress)
                    }

                    // ── Progress arc (just inside the ticks) ──────────
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            accentColor,
                            style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                        )
                        .frame(width: arcDiameter, height: arcDiameter)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: accentColor.opacity(0.9), radius: 6)

                    // ── Center dark sphere ─────────────────────────────
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(white: 0.14),
                                    Color(white: 0.06),
                                    Color.black
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 72
                            )
                        )
                        .frame(width: 144, height: 144)

                    // ── Percentage label ───────────────────────────────
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 36, weight: .semibold, design: .monospaced))
                        .foregroundStyle(accentColor)
                        .shadow(color: accentColor.opacity(0.7), radius: 8)
                }
            }
        }
    }

    // MARK: – Tick helper

    @ViewBuilder
    private func tickView(index: Int, progress: CGFloat) -> some View {
        let tickFraction = CGFloat(index) / CGFloat(tickCount)
        let angle        = Double(index) / Double(tickCount) * 360.0  // 0° = top, clockwise
        let isActive     = tickFraction <= progress

        // Ticks near the leading edge glow brighter
        let distToFront  = max(0, progress - tickFraction)
        let glowFade     = isActive ? max(0.0, 1.0 - distToFront / 0.15) : 0.0

        RoundedRectangle(cornerRadius: 2)
            .fill(isActive ? accentColor : dimColor)
            .opacity(isActive ? 0.6 + 0.4 * glowFade : 0.35)
            .frame(width: tickWidth, height: tickHeight)
            .shadow(
                color: isActive ? accentColor.opacity(0.5 + 0.5 * glowFade) : .clear,
                radius: 6 + 4 * glowFade
            )
            .offset(y: -tickRadius)
            .rotationEffect(.degrees(angle - 90))  // -90 so index 0 starts at 12 o'clock
    }
}

#Preview {
    CircleTickLoader()
}
