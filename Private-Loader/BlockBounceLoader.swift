//
//  BlockBounceLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 17/03/26.
//

import SwiftUI

struct BlockBounceLoader: View {
    @State private var animating = false

    private let colors: [Color] = [
        Color("Block1"), Color("Block2"), Color("Block3"), Color("Block4")
    ]
    private let blockSize: CGFloat  = 46
    private let cornerRadius: CGFloat = 10
    private let jumpHeight: CGFloat  = 28
    private let spacing: CGFloat     = 8

    var body: some View {
        ZStack {
            Color("BlockBackground")
                .ignoresSafeArea()

            HStack(spacing: spacing) {
                ForEach(0..<4, id: \.self) { i in
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(colors[i])
                        .frame(width: blockSize, height: blockSize)
                        .offset(y: animating ? -jumpHeight : 0)
                        .animation(
                            .easeInOut(duration: 0.45)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.12),
                            value: animating
                        )
                }
            }
        }
        .onAppear {
            animating = true
        }
    }
}

#Preview {
    BlockBounceLoader()
}
