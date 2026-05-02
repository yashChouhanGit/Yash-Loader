//
//  NativeSpinnerLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 02/05/26.
//

import SwiftUI

struct NativeSpinnerLoader: View {
    private let segmentCount = 12
    private let radius: CGFloat = 40
    private let bladeWidth: CGFloat = 10
    private let bladeHeight: CGFloat = 24
    private let cornerRadius: CGFloat = 5
    private let period: Double = 1.0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            TimelineView(.animation) { tl in
                let phase = (tl.date.timeIntervalSinceReferenceDate / period)
                    .truncatingRemainder(dividingBy: 1.0)
                spinnerView(phase: phase)
            }
        }
    }

    private func spinnerView(phase: Double) -> some View {
        ZStack {
            ForEach(0..<segmentCount, id: \.self) { i in
                let angleDeg = Double(i) / Double(segmentCount) * 360.0
                let slotPhase = Double(i) / Double(segmentCount)
                // diff = 0 → head (darkest), diff → 1 → just behind head (lightest)
                let diff = (slotPhase - phase + 1.0).truncatingRemainder(dividingBy: 1.0)
                let brightness = 0.08 + diff * 0.78

                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(white: brightness))
                    .frame(width: bladeWidth, height: bladeHeight)
                    .offset(y: -radius)
                    .rotationEffect(.degrees(angleDeg))
            }
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    NativeSpinnerLoader()
}
