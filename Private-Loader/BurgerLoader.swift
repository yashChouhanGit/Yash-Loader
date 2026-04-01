//
//  BurgerLoader.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 01/04/26.
//

import SwiftUI

struct BurgerLoader: View {

    // EatStreet / Shake-Shack green
    private let green  = Color(red: 0.290, green: 0.710, blue: 0.220)
    private let sw: CGFloat    = 6.0
    private let period: Double = 1.3
    private let amp:    Double = 6.5

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            TimelineView(.animation) { tl in
                Canvas { ctx, size in
                    var c = ctx
                    drawBurger(&c, size: size, t: tl.date.timeIntervalSinceReferenceDate)
                }
                .frame(width: 200, height: 200)
            }
        }
    }

    // ── Drawing ───────────────────────────────────────────────────────────────

    private func drawBurger(_ ctx: inout GraphicsContext, size: CGSize, t: Double) {
        let cx = size.width / 2
        let ω  = 2 * .pi / period

        // Three staggered vertical offsets (top, middle, bottom)
        let dy0 = CGFloat(amp * sin(ω * t))
        let dy1 = CGFloat(amp * sin(ω * t - 0.55))
        let dy2 = CGFloat(amp * sin(ω * t - 1.10))

        let shade = GraphicsContext.Shading.color(green)
        let sty   = StrokeStyle(lineWidth: sw, lineCap: .round, lineJoin: .round)

        // ── Geometry (burger centred in the 200×200 canvas) ─────────────────
        let domeRadius: CGFloat = 54          // semicircle half-width = burger half-width
        let domePivotY: CGFloat = 82          // arc centre = bottom of dome  → dome top at y=28
        let sepW:       CGFloat = 122         // separator-line width (≈ bun diameter)
        let patW:       CGFloat = 90          // patty W width (slightly inset)
        let bunW:       CGFloat = 122
        let bunH:       CGFloat = 26
        let bunCorner:  CGFloat = 13

        // 1 ── Top bun dome (open upward semicircle)
        var dome = Path()
        dome.addArc(
            center: CGPoint(x: cx, y: domePivotY + dy0),
            radius: domeRadius,
            startAngle: .degrees(180), endAngle: .degrees(0),
            clockwise: false
        )
        ctx.stroke(dome, with: shade, style: sty)

        // 2 ── Upper separator pair (two rounded horizontal lines)
        ctx.stroke(hLine(cx, y:  90 + dy1, w: sepW), with: shade, style: sty)
        ctx.stroke(hLine(cx, y: 101 + dy1, w: sepW), with: shade, style: sty)

        // 3 ── Patty / cheese: single-V shape (flat → dip → flat)
        ctx.stroke(pattyPath(cx, y: 112 + dy1, w: patW, dip: 12), with: shade, style: sty)

        // 4 ── Lower separator pair
        ctx.stroke(hLine(cx, y: 127 + dy2, w: sepW), with: shade, style: sty)
        ctx.stroke(hLine(cx, y: 138 + dy2, w: sepW), with: shade, style: sty)

        // 5 ── Bottom bun (closed rounded rect)
        let bunRect = CGRect(x: cx - bunW / 2, y: 147 + dy2, width: bunW, height: bunH)
        ctx.stroke(Path(roundedRect: bunRect, cornerRadius: bunCorner),
                   with: shade, style: sty)
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    /// Horizontal line centred at cx
    private func hLine(_ cx: CGFloat, y: CGFloat, w: CGFloat) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: cx - w / 2, y: y))
        p.addLine(to: CGPoint(x: cx + w / 2, y: y))
        return p
    }

    /// Flat–V–flat patty shape (single central dip, cheese-edge style)
    private func pattyPath(_ cx: CGFloat, y: CGFloat, w: CGFloat, dip: CGFloat) -> Path {
        var p = Path()
        let x0 = cx - w / 2
        p.move(to:    CGPoint(x: x0,            y: y))
        p.addLine(to: CGPoint(x: x0 + w * 0.28, y: y))
        p.addLine(to: CGPoint(x: x0 + w * 0.42, y: y + dip))
        p.addLine(to: CGPoint(x: x0 + w * 0.58, y: y + dip))
        p.addLine(to: CGPoint(x: x0 + w * 0.72, y: y))
        p.addLine(to: CGPoint(x: x0 + w,        y: y))
        return p
    }
}

#Preview {
    BurgerLoader()
}
