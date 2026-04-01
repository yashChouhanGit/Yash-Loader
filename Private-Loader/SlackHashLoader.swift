//
//  SlackHashLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 01/04/26.
//

import SwiftUI

struct SlackHashLoader: View {

    @State private var rotation: Double = 18

    // Slack brand colours
    private let green  = Color(red: 0.180, green: 0.714, blue: 0.490)   // #2EB67D
    private let yellow = Color(red: 0.925, green: 0.698, blue: 0.180)   // #ECB22E
    private let teal   = Color(red: 0.212, green: 0.773, blue: 0.941)   // #36C5F0
    private let pink   = Color(red: 0.878, green: 0.118, blue: 0.353)   // #E01E5A

    private let thickness: CGFloat = 20
    private let length:    CGFloat = 90
    private let gap:       CGFloat = 25          // centre-to-centre of parallel bars

    var body: some View {
        ZStack {
            Color(red: 0.937, green: 0.965, blue: 0.973).ignoresSafeArea()

            ZStack {
                // Vertical bars (left → green, right → yellow)
                bar(teal)  .offset(y: -gap / 2)                    // top horizontal
                bar(yellow).rotationEffect(.degrees(90)).offset(x:  gap / 2) // right vertical
                bar(green) .rotationEffect(.degrees(90)).offset(x: -gap / 2) // left vertical
                bar(pink)  .offset(y:  gap / 2)                    // bottom horizontal
            }
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(
                    .linear(duration: 2.4)
                    .repeatForever(autoreverses: false)
                ) {
                    rotation = 18 + 360
                }
            }
        }
    }

    private func bar(_ color: Color) -> some View {
        Capsule()
            .fill(color)
            .frame(width: length, height: thickness)
            .blendMode(.multiply)
    }
}

#Preview {
    SlackHashLoader()
}
