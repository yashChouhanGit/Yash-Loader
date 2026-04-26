//
//  GearMeshLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 26/04/26.
//

import SwiftUI

struct GearMeshLoader: View {

    private let bigSize:     CGFloat = 80
    private let smallSize:   CGFloat = 48
    // Speed ratio keeps tangential velocity equal at the mesh point
    private let bigPeriod:   Double  = 3.0
    private let smallPeriod: Double  = 1.8   // 3.0 × (48 / 80)
    private let spacing:     CGFloat = 68

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            TimelineView(.animation) { tl in
                let t = tl.date.timeIntervalSinceReferenceDate
                gearsView(
                    bigAngle:   (t / bigPeriod).truncatingRemainder(dividingBy: 1)   * 360,
                    smallAngle: (t / smallPeriod).truncatingRemainder(dividingBy: 1) * 360
                )
            }
        }
    }

    private func gearsView(bigAngle: Double, smallAngle: Double) -> some View {
        ZStack {
            smallGear(angle: -smallAngle, x: -spacing)
            centerGear(angle: bigAngle)
            smallGear(angle: -smallAngle, x:  spacing)
        }
    }

    private func centerGear(angle: Double) -> some View {
        Image(systemName: "gearshape.fill")
            .font(.system(size: bigSize))
            .foregroundStyle(
                LinearGradient(
                    colors: [Color(white: 0.95), Color(white: 0.50)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: .white.opacity(0.28), radius: 18)
            .rotationEffect(.degrees(angle))
    }

    private func smallGear(angle: Double, x: CGFloat) -> some View {
        Image(systemName: "gearshape.fill")
            .font(.system(size: smallSize))
            .foregroundStyle(
                LinearGradient(
                    colors: [Color(red: 1.00, green: 0.72, blue: 0.18),
                             Color(red: 0.88, green: 0.40, blue: 0.00)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: Color(red: 1, green: 0.55, blue: 0).opacity(0.70), radius: 14)
            .rotationEffect(.degrees(angle))
            .offset(x: x)
    }
}

#Preview {
    GearMeshLoader()
}
