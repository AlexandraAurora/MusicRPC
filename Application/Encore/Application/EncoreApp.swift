//
//  EncoreApp.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

// TODO: rewrite the preferences panel (extract common code)
// TODO: add codelaby credits
// TODO: use the new logger (or an existing one?)
// TODO: implement disable caching
// TODO: implement disable logging
// TODO: preferences (presets [local, cloud, custom {detect currently playing app} | use localized or custom name for preset | type {song, content or game} | what to display on the status | custom search api button], show odesli button, cover provider [itunes, encore] {}, use data from the app id [top title and appicon])
// TODO: implement sparkle
// TODO: add website support

// TODO: app icon & menu bar icon
// TODO: add documentation

@main internal struct EncoreApp: App {
    internal static let kWindowMinimumWidth: CGFloat = 630
    internal static let kWindowMinimumHeight: CGFloat = 450
    internal static let kWindowSidebarMinimumWidth: CGFloat = 160
    internal static let kWindowInsetLarge: CGFloat = 32
    internal static let kWindowInsetSmall: CGFloat = 16
    internal static let kItemSpacing: CGFloat = 12
    internal static let kDescriptionSpacing: CGFloat = 4

    private let bridge: EncoreCoreBridge = .init()
    private let preferencesState: PreferencesState = .init()

    internal var body: some Scene {
        MenuBarExtra(Bundle.main.bundleName, systemImage: "music.note") {
            MenuBarView(bridge: self.bridge, preferencesState: self.preferencesState)
        }

        Window("", id: "preferences") {
            PreferencesView(bridge: self.bridge, state: self.preferencesState)
        }
        .defaultSize(width: Self.kWindowMinimumWidth, height: Self.kWindowMinimumHeight)
        .windowResizability(.contentMinSize)
    }
}
