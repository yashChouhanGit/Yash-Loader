//
//  NeonInfinityLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 28/03/26.
//

import SwiftUI

struct NeonInfinityLoader: View {
    private let cycleDuration = 2.8

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TimelineView(.animation) { tl in
                let elapsed  = tl.date.timeIntervalSinceReferenceDate
                let progress = (elapsed / cycleDuration).truncatingRemainder(dividingBy: 1.0)

                VStack(spacing: 18) {
                    InfinityCanvas(progress: progress)
                        .frame(width: 320, height: 200)

                    Text("Loading...")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color(white: 0.55))
                }
            }
        }
    }
}

// MARK: – Canvas

private struct InfinityCanvas: View {

    let progress: Double

    // Path shape (lemniscate): x = W·sin(t), y = H·sin(t)·cos(t)
    private let W: CGFloat = 68   // horizontal half-amplitude
    private let H: CGFloat = 38   // vertical half-amplitude

    private let lineWidth: CGFloat   = 4.5
    private let trailFraction        = 0.52   // fraction of path that is "lit"
    private let steps                = 600    // path resolution

    // Colours
    private let dimGray   = Color(white: 0.18)
    private let coreWhite = Color.white
    private let glowBlue  = Color(red: 0.55, green: 0.70, blue: 1.00)
    private let bloomPurp = Color(red: 0.38, green: 0.22, blue: 0.90)

    // Lemniscate point, frac ∈ [0, 1)
    private func pt(_ frac: Double, cx: CGFloat, cy: CGFloat) -> CGPoint {
        let t = frac * 2 * Double.pi
        return CGPoint(x: cx + W * sin(t),
                       y: cy + H * sin(t) * cos(t))
    }

    // Build a Path from tailFrac → headFrac (handles 0-wrap automatically)
    private func trailPath(cx: CGFloat, cy: CGFloat) -> Path {
        let sampleCount = Int(Double(steps) * trailFraction) + 2
        var path = Path()
        for i in 0...sampleCount {
            let frac = (Double(i) / Double(sampleCount) * trailFraction
                        + (progress - trailFraction + 1.0))
                        .truncatingRemainder(dividingBy: 1.0)
            let p = pt(frac, cx: cx, cy: cy)
            if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
        }
        return path
    }

    // Full infinity path (closed)
    private func fullPath(cx: CGFloat, cy: CGFloat) -> Path {
        var path = Path()
        for i in 0...steps {
            let p = pt(Double(i) / Double(steps), cx: cx, cy: cy)
            if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
        }
        path.closeSubpath()
        return path
    }

    var body: some View {
        Canvas { ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2

            // ── 1. Dim background ring ──────────────────────────────────
            ctx.stroke(fullPath(cx: cx, cy: cy),
                       with: .color(dimGray),
                       lineWidth: lineWidth)

            // ── 2. Large purple atmospheric bloom ──────────────────────
            ctx.drawLayer { lc in
                lc.addFilter(.blur(radius: 28))
                lc.stroke(trailPath(cx: cx, cy: cy),
                          with: .color(bloomPurp.opacity(0.55)),
                          lineWidth: lineWidth * 5)
            }

            // ── 3. Mid blue glow ─────────────────────────────────────
            ctx.drawLayer { lc in
                lc.addFilter(.blur(radius: 10))
                lc.stroke(trailPath(cx: cx, cy: cy),
                          with: .color(glowBlue.opacity(0.75)),
                          lineWidth: lineWidth * 2.5)
            }

            // ── 4. Tight inner glow ───────────────────────────────────
            ctx.drawLayer { lc in
                lc.addFilter(.blur(radius: 3))
                lc.stroke(trailPath(cx: cx, cy: cy),
                          with: .color(glowBlue.opacity(0.90)),
                          lineWidth: lineWidth * 1.4)
            }

            // ── 5. Core bright stroke ─────────────────────────────────
            ctx.stroke(trailPath(cx: cx, cy: cy),
                       with: .color(coreWhite),
                       lineWidth: lineWidth)

            // ── 6. Head dot layers (outer bloom → core) ───────────────
            let head = pt(progress, cx: cx, cy: cy)

            let dotLayers: [(blur: CGFloat, size: CGFloat, opacity: Double, color: Color)] = [
                (36, 90, 0.25, bloomPurp),
                (18, 32, 0.55, bloomPurp),
                (8,  16, 0.80, glowBlue),
                (3,  9,  0.95, coreWhite),
                (0,  4,  1.00, coreWhite),
            ]

            for layer in dotLayers {
                ctx.drawLayer { lc in
                    if layer.blur > 0 { lc.addFilter(.blur(radius: layer.blur)) }
                    let r = layer.size / 2
                    let rect = CGRect(x: head.x - r, y: head.y - r,
                                      width: layer.size, height: layer.size)
                    lc.fill(Path(ellipseIn: rect),
                            with: .color(layer.color.opacity(layer.opacity)))
                }
            }
        }
    }
}

#Preview {
    NeonInfinityLoader()
}
