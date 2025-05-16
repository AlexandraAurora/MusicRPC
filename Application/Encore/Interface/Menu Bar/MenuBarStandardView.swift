//
//  MenuBarStandardView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import SwiftUI

internal struct MenuBarStandardView: View {
    internal var preferencesState: PreferencesState
    @Environment(\.openWindow) private var openWindow

    internal var body: some View {
        VStack {
            Button("MENU_BAR_ABOUT".localizedWithEnglishFallback(Bundle.main.bundleName)) {
                preferencesState.selectedTab = .about
                openWindow(id: "preferences")
                NSApp.activate(ignoringOtherApps: true)
            }

            Button("MENU_BAR_PREFERENCES".localizedWithEnglishFallback()) {
                openWindow(id: "preferences")
                NSApp.activate(ignoringOtherApps: true)
            }
            .keyboardShortcut(.init(",", modifiers: [.command]))

            Divider()

            Button("MENU_BAR_QUIT".localizedWithEnglishFallback(Bundle.main.bundleName)) {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut(.init("Q", modifiers: [.command]))
        }
    }
}
