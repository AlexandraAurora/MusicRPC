//
//  MenuBarView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

internal struct MenuBarView: View {
    internal let bridge: EncoreCoreBridge
    internal let preferencesState: PreferencesState

    internal var body: some View {
        MenuBarActivityView(bridge: self.bridge)
        Divider()
        MenuBarStandardView(preferencesState: self.preferencesState)
    }
}
