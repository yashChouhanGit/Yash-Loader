//
//  SimpleArcLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 17/03/26.
//

import SwiftUI
//MARK: In Progress
struct SimpleArcLoader: View {
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Color("SimpleBackground")
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Loading... Please Wait...")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color("SimpleText"))

                Circle()
                    .trim(from: 0.0, to: 0.75)
                    .stroke(
                        Color("SimpleArc"),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(rotation))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    SimpleArcLoader()
}
