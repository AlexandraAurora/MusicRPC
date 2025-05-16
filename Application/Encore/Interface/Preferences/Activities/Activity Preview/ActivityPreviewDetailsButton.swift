//
//  ActivityPreviewDetailsButton.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import SwiftUI

internal struct ActivityPreviewDetailsButton: View {
    internal let title: String
    internal let url: URL

    internal var body: some View {
        Button {
            NSWorkspace.shared.open(self.url)
        } label: {
            Text(self.title)
                .font(.custom(ActivityPreview.kFontFamilyText, size: ActivityPreview.kTextSizeText))
                .frame(maxWidth: .infinity, minHeight: 30)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.secondary.opacity(0.4), lineWidth: 0.5)
        )
    }
}
