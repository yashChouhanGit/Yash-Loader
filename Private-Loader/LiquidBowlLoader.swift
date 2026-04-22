//
//  LiquidBowlLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 22/04/26.
//

import SwiftUI

// MARK: - Private Shapes

/// Filled liquid body with a sinusoidal wave surface.
/// The frame should be a square (diameter × diameter) — clipped externally to a Circle.
private struct LiquidWave: Shape {
    /// 0–1: fraction filled (0 = empty, 1 = full).
    var progress: Double
    /// 0–1: horizontal phase — animated continuously for wave motion.
    var wavePhase: Double
    var amplitude: CGFloat = 7

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        let wavelength = w * 0.7
        let liquidY = h * CGFloat(1 - progress)
        let shift = CGFloat(wavePhase) * wavelength

        p.move(to: .init(x: 0, y: h))
        p.addLine(to: .init(x: 0, y: liquidY))
        for xi in 0...Int(w) {
            let x = CGFloat(xi)
            p.addLine(to: .init(x: x, y: liquidY + amplitude * sin(2 * .pi * (x + shift) / wavelength)))
        }
        p.addLine(to: .init(x: w, y: h))
        p.closeSubpath()
        return p
    }
}

// MARK: - LiquidBowlLoader

/// Drop-in loader: counts 1→100 in a loop.
/// Liquid level inside the circle always matches the displayed percentage.
struct LiquidBowlLoader: View {

    // MARK: Configuration
    var diameter: CGFloat   = 220
    var cycleDuration: Double = 3.5   // seconds per 0→100 cycle
    var waveSpeed: Double   = 1.6     // seconds per wave period
    var fillColor: Color    = Color(red: 0.40, green: 0.46, blue: 0.82)
    var foamColor: Color    = Color(red: 0.70, green: 0.82, blue: 1.00)
    var bgColor: Color      = Color(red: 0.04, green: 0.05, blue: 0.18)

    // MARK: Body

    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()

            TimelineView(.animation) { tl in
                let t        = tl.date.timeIntervalSinceReferenceDate
                let progress = (t / cycleDuration).truncatingRemainder(dividingBy: 1.0)
                let phase    = (t / waveSpeed).truncatingRemainder(dividingBy: 1.0)

                circleView(progress: progress, phase: phase)
            }
        }
    }

    // MARK: Private

    @ViewBuilder
    private func circleView(progress: Double, phase: Double) -> some View {
        ZStack {
            // Liquid body — clipped to full circle
            LiquidWave(progress: progress, wavePhase: phase, amplitude: 7)
                .fill(fillColor)
                .frame(width: diameter, height: diameter)
                .clipShape(Circle())

            // Lighter foam crest (slightly ahead in phase)
            LiquidWave(progress: progress, wavePhase: phase + 0.12, amplitude: 5)
                .fill(foamColor.opacity(0.35))
                .frame(width: diameter, height: diameter)
                .clipShape(Circle())

            // Percentage — pinned to the geometric centre of the circle, never moves
            Text("\(max(1, Int(progress * 100) + 1))%")
                .font(.system(size: 40, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.35), radius: 3)
        }
    }
}

// MARK: - Preview

#Preview {
    LiquidBowlLoader()
}
