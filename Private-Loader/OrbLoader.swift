//
//  OrbLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 17/03/26.
//

import SwiftUI

struct OrbLoader: View {
    @State private var rotation: Double = 0

    private let ringCount = 24
    private let ringWidth: CGFloat = 130
    private let ringHeight: CGFloat = 110
    private let dotSize: CGFloat = 16
    private let orbitRadius: CGFloat = 55

    var body: some View {
        ZStack {
            Color("OrbBackground")
                .ignoresSafeArea()

            VStack(spacing: 10) {
                ZStack {
                    // Multi-ring coil effect
                    ForEach(0..<ringCount, id: \.self) { i in
                        let angle = Double(i) * (180.0 / Double(ringCount))
                        let xOff = CGFloat(sin(angle * .pi / 180) * 3)
                        let yOff = CGFloat(cos(angle * .pi / 180) * 2)

                        Ellipse()
                            .stroke(
                                Color("OrbRing").opacity(0.18),
                                lineWidth: 2
                            )
                            .frame(width: ringWidth, height: ringHeight)
                            .rotationEffect(.degrees(angle))
                            .offset(x: xOff, y: yOff)
                    }

                    // Orbiting white dot
                    Circle()
                        .fill(Color.white)
                        .frame(width: dotSize, height: dotSize)
                        .shadow(color: .white.opacity(0.9), radius: 8,  x: 0, y: 0)
                        .shadow(color: .white.opacity(0.5), radius: 16, x: 0, y: 0)
                        .offset(y: -orbitRadius)
                        .rotationEffect(.degrees(rotation))
                }

                // Shadow / reflection below
                Ellipse()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color("OrbRing").opacity(0.35),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 42
                        )
                    )
                    .frame(width: 90, height: 14)
                    .blur(radius: 5)
            }
        }
        .onAppear {
            withAnimation(
                .linear(duration: 2.2)
                .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
    }
}

#Preview {
    OrbLoader()
}
