//
//  ActivityPreviewDetailsView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

internal struct ActivityPreviewDetailsView: View {
    @ObservedObject internal var bridge: EncoreCoreBridge

    internal var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            ActivityTextView(text: self.bridge.title ?? "", size: ActivityPreview.kTextSizeTitle, isBold: true)
            ActivityTextView(text: self.bridge.subtitle ?? "", size: ActivityPreview.kTextSizeText, isBold: false)
            ActivityTextView(text: self.bridge.details ?? "", size: ActivityPreview.kTextSizeText, isBold: false)
            ActivityPreviewDetailsProgressView(bridge: self.bridge)
                .padding(.top, 4)
                .padding(.bottom, 8)
            let queryParameterRaw: String = "\(self.bridge.title ?? "") \(self.bridge.subtitle ?? "") \(self.bridge.details ?? "")"
            let queryParameter: String = queryParameterRaw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            ActivityPreviewDetailsButton(title: "Search on Apple Music", url: URL(string: "https://music.apple.com/search?term=\(queryParameter)")!)
        }
    }
}

private struct ActivityTextView: View {
    internal let text: String
    internal let size: CGFloat
    internal let isBold: Bool

    internal var body: some View {
        Text(self.text)
            .font(.custom(ActivityPreview.kFontFamilyText, size: self.size))
            .fontWeight(self.isBold ? .bold : .regular)
            .lineLimit(1)
    }
}
