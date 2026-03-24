//
//  BarScanLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 24/03/26.
//

import SwiftUI

struct BarScanLoader: View {

    // MARK: – Constants
    private let accentColor  = Color(red: 0.39, green: 0.85, blue: 0.72)  // mint/teal
    private let bgColor      = Color(red: 0.17, green: 0.25, blue: 0.33)  // dark navy
    private let segmentCount = 52
    private let segmentWidth: CGFloat = 5
    private let segmentGap:   CGFloat = 2.5
    private let barWidth:     CGFloat = 320
    private let barHeight:    CGFloat = 56
    private let duration:     Double  = 2.2   // seconds per full sweep

    var body: some View {
        // TimelineView fires on every display frame → smooth per-frame opacity
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSinceReferenceDate
            let sweep   = CGFloat(elapsed.truncatingRemainder(dividingBy: duration) / duration)

            ZStack {
                bgColor.ignoresSafeArea()

                VStack(spacing: 18) {

                    // ── Label ──────────────────────────────────────────
                    Text("loading...")
                        .font(.system(size: 22, weight: .regular, design: .rounded))
                        .foregroundStyle(accentColor)

                    // ── Bar ────────────────────────────────────────────
                    ZStack {
                        // Pill fill
                        Capsule()
                            .fill(bgColor)

                        // Segments — clipped so they never overflow the pill
                        HStack(spacing: segmentGap) {
                            ForEach(0..<segmentCount, id: \.self) { i in
                                Rectangle()
                                    .fill(accentColor.opacity(segmentOpacity(index: i, sweep: sweep)))
                                    .frame(width: segmentWidth)
                            }
                        }
                        .padding(.horizontal, 14)
                        .clipShape(Capsule())          // clips segment edges to pill

                        // Teal border — drawn on top
                        Capsule()
                            .strokeBorder(accentColor, lineWidth: 2.5)
                    }
                    .frame(width: barWidth, height: barHeight)
                }
                .padding()
            }
        }
    }

    // MARK: – Helpers

    /// Opacity for segment at `index` given sweep in 0…1.
    /// - Ahead of wave front  →  nearly invisible (0.10)
    /// - At the wave front    →  full brightness  (1.00)
    /// - Behind the wave      →  fades to dim     (0.18)
    private func segmentOpacity(index: Int, sweep: CGFloat) -> Double {
        let pos     = Double(index) / Double(segmentCount - 1)   // 0…1
        let s       = Double(sweep)
        let waveLen = 0.28   // bright zone width as fraction of bar

        if pos > s {
            return 0.10   // not yet reached
        }
        let lag = s - pos
        if lag < waveLen {
            // smooth ease from bright (lag=0) to dim (lag=waveLen)
            let t = lag / waveLen
            return 0.18 + 0.82 * (1.0 - t * t)   // quadratic ease-out
        }
        return 0.18   // fully passed
    }
}

#Preview {
    BarScanLoader()
}
