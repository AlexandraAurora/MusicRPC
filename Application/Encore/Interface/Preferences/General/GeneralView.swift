//
//  GeneralSettingsTab.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCore
import ServiceManagement
import SwiftUI

internal struct GeneralView: View {
    @State private var launchAtLogin: Bool = SMAppService.mainApp.status == .enabled
    @AppStorage("isCachingEnabled") private var isCachingEnabled: Bool = true
    @AppStorage("isLoggingEnabled") private var isLoggingEnabled: Bool = false

    internal var body: some View {
        GroupContainer {
            VStack(alignment: .leading, spacing: .zero) {
                HStack(alignment: .center, spacing: .zero) {
                    Text("PREFERENCES_TAB_GENERAL_ENABLE_LAUNCH_AT_LOGIN".localizedWithEnglishFallback())

                    Spacer()

                    Toggle("", isOn: Binding(
                        get: {
                            launchAtLogin
                        },
                        set: { enabled in
                            if enabled {
                                try? SMAppService.mainApp.register()
                            } else {
                                try? SMAppService.mainApp.unregister()
                            }
                            launchAtLogin = SMAppService.mainApp.status == .enabled
                        }
                    ))
                    .preferencesStyle()
                }

                Divider()
                    .padding(.vertical, EncoreApp.kItemSpacing)

                VStack(alignment: .leading, spacing: .zero) {
                    HStack(alignment: .center, spacing: .zero) {
                        Text("PREFERENCES_TAB_GENERAL_ENABLE_CACHING".localizedWithEnglishFallback())
                        Spacer()
                        Toggle("", isOn: $isCachingEnabled)
                            .preferencesStyle()
                    }
                    Text("PREFERENCES_TAB_GENERAL_ENABLE_CACHING_DESCRIPTION".localizedWithEnglishFallback())
                        .preferencesDescriptionStyle()
                }
            }
        }
        .padding(.bottom, EncoreApp.kItemSpacing)

        GroupContainer {
            VStack(alignment: .leading, spacing: .zero) {
                HStack(alignment: .center, spacing: .zero) {
                    Text("PREFERENCES_TAB_GENERAL_ENABLE_LOGGING".localizedWithEnglishFallback())
                    Spacer()
                    Toggle("", isOn: $isLoggingEnabled)
                        .preferencesStyle()
                }

                Text("PREFERENCES_TAB_GENERAL_ENABLE_LOGGING_DESCRIPTION".localizedWithEnglishFallback())
                    .preferencesDescriptionStyle()
                    .padding(.bottom, EncoreApp.kItemSpacing / 2)

                Button("PREFERENCES_TAB_GENERAL_OPEN_LOGS_FOLDER".localizedWithEnglishFallback()) {
                    Logger.sharedInstance().ensureFileSystem()
                    NSWorkspace.shared.open(URL(fileURLWithPath: Logger.sharedInstance().logsPath()))
                }
            }
        }
    }
}
