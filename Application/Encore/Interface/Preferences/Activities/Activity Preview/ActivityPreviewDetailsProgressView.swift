//
//  ActivityPreviewDetailsProgressView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

internal struct ActivityPreviewDetailsProgressView: View {
    @ObservedObject internal var bridge: EncoreCoreBridge
    @State private var localElapsed: CGFloat = .zero

    internal var body: some View {
        HStack(spacing: .zero) {
            ActivityDetailsTimestampView(timestamp: self.localElapsed)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.primary.opacity(0.2))
                    Capsule()
                        .fill(.primary)
                        .frame(width: geometry.size.width * (self.bridge.duration ?? .zero > .zero ? (self.localElapsed) / (self.bridge.duration ?? .zero) : .zero))
                }
            }
            .frame(height: 2)
            .padding(.horizontal, 8)

            ActivityDetailsTimestampView(timestamp: self.bridge.duration ?? .zero)
        }
        .onAppear {
            localElapsed = bridge.elapsed ?? .zero
        }
        .onChange(of: bridge.elapsed) { _, newElapsed in
            localElapsed = newElapsed ?? .zero
        }
        .onChange(of: bridge.duration) { _, _ in
            localElapsed = .zero
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if (bridge.isPlaying ?? false) {
                localElapsed += 1
            }
        }
    }
}

private struct ActivityDetailsTimestampView: View {
    internal let timestamp: CGFloat

    internal var body: some View {
        Text(self.formattedTimestamp(fromTimestamp: self.timestamp))
            .font(.custom(ActivityPreview.kFontFamilyProgress, size: ActivityPreview.kTextSizeText))
            .contentTransition(.numericText())
    }

    private func formattedTimestamp(fromTimestamp timestamp: CGFloat) -> String {
        let totalSeconds: Int = Int(timestamp)
        let minutes: Int = totalSeconds / 60
        let seconds: Int = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
