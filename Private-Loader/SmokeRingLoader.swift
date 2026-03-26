//
//  SmokeRingLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 26/03/26.
//

import SwiftUI

struct SmokeRingLoader: View {
    @State private var startDate = Date()

    private let ringRadius: CGFloat = 105
    private let frameSize:  CGFloat = 300

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TimelineView(.animation) { timeline in
                let elapsed = timeline.date.timeIntervalSince(startDate)
                let phase   = elapsed * 1.6
                let rotDeg  = elapsed * 10        // slow continuous spin

                ZStack {
                    // Outer diffuse glow
                    smokeRing(phase: phase,         amp: 18, width: 54, opacity: 0.055).blur(radius: 22)
                    smokeRing(phase: phase + 0.30,  amp: 15, width: 37, opacity: 0.100).blur(radius: 12)
                    // Mid smoke body
                    smokeRing(phase: phase + 0.55,  amp: 12, width: 23, opacity: 0.195).blur(radius: 6)
                    smokeRing(phase: phase + 0.10,  amp: 10, width: 14, opacity: 0.310).blur(radius: 3)
                    // Bright inner edge
                    smokeRing(phase: phase + 0.25,  amp:  8, width:  6, opacity: 0.550).blur(radius: 1.5)
                    smokeRing(phase: phase,          amp:  6, width:  2, opacity: 0.900)
                }
                .rotationEffect(.degrees(rotDeg))
                .frame(width: frameSize, height: frameSize)
            }
        }
        .onAppear { startDate = Date() }
    }

    // Single wavy-ring stroke drawn on a Canvas
    @ViewBuilder
    private func smokeRing(phase: Double,
                           amp:   CGFloat,
                           width: CGFloat,
                           opacity: Double) -> some View {
        Canvas { ctx, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            var path = Path()
            let steps = 400

            for i in 0...steps {
                let t   = Double(i) / Double(steps)
                let ang = t * .pi * 2

                // Layered sine waves → organic smoke/plasma texture
                let a = Double(amp)
                let w1 = sin(ang *  5.0 + phase)        * a
                let w2 = sin(ang *  9.0 + phase * 1.40) * a * 0.50
                let w3 = sin(ang * 14.0 + phase * 0.85) * a * 0.28
                let w4 = sin(ang * 21.0 + phase * 1.65) * a * 0.14
                let w5 = sin(ang * 31.0 + phase * 2.10) * a * 0.07
                let wave = CGFloat(w1 + w2 + w3 + w4 + w5)

                let r  = ringRadius + wave
                let pt = CGPoint(
                    x: center.x + CGFloat(cos(ang)) * r,
                    y: center.y + CGFloat(sin(ang)) * r
                )
                i == 0 ? path.move(to: pt) : path.addLine(to: pt)
            }
            path.closeSubpath()
            ctx.stroke(path, with: .color(.white.opacity(opacity)), lineWidth: width)
        }
    }
}

#Preview {
    SmokeRingLoader()
}
