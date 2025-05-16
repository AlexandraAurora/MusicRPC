//
//  ActivityPreview.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

internal struct ActivityPreview: View {
    internal static let kTextSizeTitle: CGFloat = 14
    internal static let kTextSizeText: CGFloat = 12
    internal static let kFontFamilyText: String = "Noto Sans"
    internal static let kFontFamilyProgress: String = "Noto Sans Mono"

    @ObservedObject internal var bridge: EncoreCoreBridge

    internal var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            if let _: String = self.bridge.applicationBundleIdentifier {
                Text("PREFERENCES_TAB_ACTIVITIES_PREVIEW_LISTENING_TO".localizedWithEnglishFallback("Apple Music"))
                    .font(.custom(Self.kFontFamilyText, size: Self.kTextSizeText))

                HStack(alignment: .top, spacing: .zero) {
                    ActivityPreviewDetailsCoverView(bridge: self.bridge)
                        .padding(.trailing, EncoreApp.kItemSpacing)
                    ActivityPreviewDetailsView(bridge: self.bridge)
                        .padding(.top, -4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, EncoreApp.kItemSpacing)
            } else {
                Text("PREFERENCES_TAB_ACTIVITIES_PREVIEW_NOT_PLAYING".localizedWithEnglishFallback())
                    .font(.custom(Self.kFontFamilyText, size: Self.kTextSizeText))
                    .foregroundStyle(.secondary)

                RoundedRectangle(cornerRadius: 8)
                    .fill(.secondary.opacity(0.15))
                    .frame(maxWidth: .infinity, minHeight: ActivityPreviewDetailsCoverView.kCoverHeight)
                    .padding(.top, EncoreApp.kItemSpacing)
                    .overlay(alignment: .center) {
                        Image(systemName: "music.note")
                            .font(.system(size: 28))
                            .foregroundStyle(.secondary.opacity(0.5))
                            .padding(.top, EncoreApp.kItemSpacing)
                    }
            }
        }
    }
}
