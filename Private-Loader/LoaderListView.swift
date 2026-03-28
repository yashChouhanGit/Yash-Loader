//
//  LoaderListView.swift
//  Private-Loader
//
//  Created by Yash Chouhan on 17/03/26.
//

import SwiftUI

struct LoaderItem: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let icon: String
}

struct LoaderListView: View {

    private let loaders: [LoaderItem] = [
        LoaderItem(name: "Orb Loader",          subtitle: "Multi-ring orb with orbiting dot", icon: "circle.circle.fill"),
        LoaderItem(name: "Neon Spiral Loader",  subtitle: "Dual arc neon glow spinner",       icon: "arrow.2.circlepath"),
        LoaderItem(name: "Dot Ring Loader",     subtitle: "Glowing dot arc spinner",          icon: "circle.grid.cross.fill"),
        LoaderItem(name: "Simple Arc Loader",   subtitle: "Classic arc spinner with label",   icon: "arrow.clockwise"),
        LoaderItem(name: "Block Bounce Loader",  subtitle: "Staggered bouncing block wave",    icon: "square.grid.2x2.fill"),
        LoaderItem(name: "Segment Ring Loader",  subtitle: "3-D segmented blue donut spinner", icon: "circle.dotted"),
        LoaderItem(name: "Bar Scan Loader",      subtitle: "Sweeping wave across teal segment bar", icon: "chart.bar.fill"),
        LoaderItem(name: "Circle Tick Loader",   subtitle: "Glowing tick ring with arc & percent",  icon: "circle.dotted.circle"),
        LoaderItem(name: "Smoke Ring Loader",    subtitle: "Organic plasma smoke ring on black",     icon: "smoke.fill"),
        LoaderItem(name: "Cross Pulse Loader",   subtitle: "4 cyan dots pulse outward in sequence",  icon: "plus.circle.fill"),
        LoaderItem(name: "Neon Counter Loader",  subtitle: "Red & blue neon rings with centre count", icon: "circle.hexagonpath.fill"),
        LoaderItem(name: "Neon Infinity Loader", subtitle: "Glowing neon head traces an infinity path", icon: "infinity"),
    ]

    var body: some View {
        NavigationStack {
            List(loaders) { item in
                NavigationLink(destination: destination(for: item)) {
                    HStack(spacing: 16) {
                        Image(systemName: item.icon)
                            .font(.title2)
                            .foregroundStyle(.tint)
                            .frame(width: 36)

                        VStack(alignment: .leading, spacing: 3) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Loaders")
        }
    }

    @ViewBuilder
    private func destination(for item: LoaderItem) -> some View {
        switch item.name {
        case "Orb Loader":
            OrbLoader()
                .navigationTitle("Orb Loader")
                .navigationBarTitleDisplayMode(.inline)
        case "Neon Spiral Loader":
            NeonSpiralLoader()
                .navigationTitle("Neon Spiral Loader")
                .navigationBarTitleDisplayMode(.inline)
        case "Dot Ring Loader":
            DotRingLoader()
                .navigationTitle("Dot Ring Loader")
                .navigationBarTitleDisplayMode(.inline)
        case "Simple Arc Loader":
            SimpleArcLoader()
                .navigationTitle("Simple Arc Loader")
                .navigationBarTitleDisplayMode(.inline)
        case "Block Bounce Loader":
            BlockBounceLoader()
                .navigationTitle("Block Bounce Loader")
                .navigationBarTitleDisplayMode(.inline)
        case "Segment Ring Loader":
            SegmentRingLoader()
                .navigationTitle("Segment Ring Loader")
                .navigationBarTitleDisplayMode(.inline)
        case "Bar Scan Loader":
            BarScanLoader()
                .navigationTitle("Bar Scan Loader")
                .navigationBarTitleDisplayMode(.inline)
        case "Circle Tick Loader":
            CircleTickLoader()
                .navigationTitle("Circle Tick Loader")
                .navigationBarTitleDisplayMode(.inline)
        case "Smoke Ring Loader":
            SmokeRingLoader()
                .navigationTitle("Smoke Ring Loader")
                .navigationBarTitleDisplayMode(.inline)
        case "Cross Pulse Loader":
            CrossPulseLoader()
                .navigationTitle("Cross Pulse Loader")
                .navigationBarTitleDisplayMode(.inline)
        case "Neon Counter Loader":
            NeonCounterLoader()
                .navigationTitle("Neon Counter Loader")
                .navigationBarTitleDisplayMode(.inline)
        case "Neon Infinity Loader":
            NeonInfinityLoader()
                .navigationTitle("Neon Infinity Loader")
                .navigationBarTitleDisplayMode(.inline)
        default:
            EmptyView()
        }
    }
}

#Preview {
    LoaderListView()
}
