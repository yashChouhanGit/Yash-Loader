//
//  SegmentRingLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 17/03/26.
//

import SwiftUI

struct SegmentRingLoader: View {
    @State private var rotation: Double = 0

    // All layers use the same frame.
    // Drawing order: PINK (widest) → PURPLE → BLUE (narrowest)
    // → PINK is visible only on the outer+inner rim edges
    // → PURPLE fills the body between pink and blue
    // → BLUE sits at the bright centre of the tube
    // Result: pink rim | purple body | blue centre | purple body | pink rim  (3-D torus)
    private let frame: CGFloat   = 182

    // Gaps (fraction 0–1, 0 = 12 o'clock clockwise)
    // Gap 1 — top (~12 o'clock):         0.000 → 0.030  (~11°)
    // Gap 2 — bottom-left (~7 o'clock):  0.570 → 0.608  (~14°)
    private let g1s: CGFloat = 0.000
    private let g1e: CGFloat = 0.030
    private let g2s: CGFloat = 0.570
    private let g2e: CGFloat = 0.608

    // Tiny blue accent just after the top gap
    private let accentEnd: CGFloat = 0.068

    var body: some View {
        ZStack {
            Color("RingBackground")
                .ignoresSafeArea()

            ZStack {

                // ═══════════════════════════════════════════════════════
                //  LARGE SEGMENT   g1e → g2s  (~194°, right + bottom)
                // ═══════════════════════════════════════════════════════

                // 1. Pink — widest, drawn first → rim edges
                Circle()
                    .trim(from: g1e, to: g2s)
                    .stroke(Color("RingPink"),
                            style: StrokeStyle(lineWidth: 52, lineCap: .butt))
                    .frame(width: frame, height: frame)

                // 2. Purple — mid width
                Circle()
                    .trim(from: g1e, to: g2s)
                    .stroke(Color("RingPurple"),
                            style: StrokeStyle(lineWidth: 36, lineCap: .butt))
                    .frame(width: frame, height: frame)

                // 3. Blue — narrowest, bright centre
                Circle()
                    .trim(from: g1e, to: g2s)
                    .stroke(Color("RingBlue"),
                            style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                    .frame(width: frame, height: frame)

                // 4. Bright blue accent at the very start of large segment
                Circle()
                    .trim(from: g1e, to: accentEnd)
                    .stroke(Color("RingBlue").opacity(0.95),
                            style: StrokeStyle(lineWidth: 36, lineCap: .butt))
                    .frame(width: frame, height: frame)

                // ═══════════════════════════════════════════════════════
                //  SMALL SEGMENT   g2e → (1 - g1e)  (~133°, upper-left)
                // ═══════════════════════════════════════════════════════

                Circle()
                    .trim(from: g2e, to: 1 - g1e)
                    .stroke(Color("RingPink"),
                            style: StrokeStyle(lineWidth: 52, lineCap: .butt))
                    .frame(width: frame, height: frame)

                Circle()
                    .trim(from: g2e, to: 1 - g1e)
                    .stroke(Color("RingPurple"),
                            style: StrokeStyle(lineWidth: 36, lineCap: .butt))
                    .frame(width: frame, height: frame)

                Circle()
                    .trim(from: g2e, to: 1 - g1e)
                    .stroke(Color("RingBlue"),
                            style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                    .frame(width: frame, height: frame)
            }
            // Align gap 1 to 12 o'clock
            .rotationEffect(.degrees(rotation - 90))
        }
        .onAppear {
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    SegmentRingLoader()
}
