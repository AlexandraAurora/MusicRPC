//
//  Toggle+PreferencesStyle.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import SwiftUI

extension Toggle {
    @MainActor internal func preferencesStyle() -> some View {
        self
            .toggleStyle(.switch)
            .controlSize(.small)
            .labelsHidden()
    }
}
