//
//  ActivityPreviewDetailsCoverView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

internal struct ActivityPreviewDetailsCoverView: View {
    private let kCoverWidth: CGFloat = 100
    internal static let kCoverHeight: CGFloat = 100
    private let kCoverMaskWidth: CGFloat = 41
    private let kCoverMaskHeight: CGFloat = 41
    private let kCoverMaskOffset: CGFloat = 39
    private let kCoverMaskIconWidth: CGFloat = 32
    private let kCoverMaskIconHeight: CGFloat = 32
    private let kPopoverMargin: CGFloat = 10

    @ObservedObject internal var bridge: EncoreCoreBridge
    @State private var showingDetailsPopover: Bool = false
    @State private var showingNowPlayingApplicationPopover: Bool = false

    internal var body: some View {
        ZStack {
            AsyncImage(url: self.bridge.coverUrl, content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)
            }, placeholder: {
                Color.secondary
            })
            .frame(width: self.kCoverWidth, height: Self.kCoverHeight)
            .onHover { hover in
                self.showingDetailsPopover = hover
            }
            .popover(isPresented: self.$showingDetailsPopover) {
                Text(self.bridge.details ?? "")
                    .padding(self.kPopoverMargin)
            }
            .reverseMask {
                Circle()
                    .frame(width: self.kCoverMaskWidth, height: self.kCoverMaskHeight)
                    .offset(x: self.kCoverMaskOffset, y: self.kCoverMaskOffset)
            }
            .overlay {
                Image("Apple Music")
                    .resizable()
                    .frame(width: self.kCoverMaskIconWidth, height: self.kCoverMaskIconHeight)
                    .onHover { hover in
                        self.showingNowPlayingApplicationPopover = hover
                    }
                    .popover(isPresented: self.$showingNowPlayingApplicationPopover) {
                        Text("PREFERENCES_TAB_ACTIVITIES_PREVIEW_SMALL_ICON_TEXT".localizedWithEnglishFallback("Apple Music"))
                            .padding(self.kPopoverMargin)
                    }
                    .clipShape(Circle())
                    .offset(x: self.kCoverMaskOffset, y: self.kCoverMaskOffset)
            }
        }
    }
}
