//
//  Text+PreferencesDescriptionStyle.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import SwiftUI

extension Text {
    @MainActor internal func preferencesDescriptionStyle() -> some View {
        self
            .font(.system(size: 11))
            .foregroundStyle(.secondary)
            .padding(.top, EncoreApp.kDescriptionSpacing)
    }
}
