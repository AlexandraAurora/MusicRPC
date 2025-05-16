//
//  PreferencesView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

internal enum PreferencesTab: Hashable {
    case about, activities, general
}

@Observable
internal final class PreferencesState {
    var selectedTab: PreferencesTab = .general
}

internal struct PreferencesView: View {
    @ObservedObject internal var bridge: EncoreCoreBridge
    @Bindable internal var state: PreferencesState

    internal var body: some View {
        NavigationSplitView {
            List(selection: $state.selectedTab) {
                Section {
                    Label("PREFERENCES_TAB_GENERAL".localizedWithEnglishFallback(), systemImage: "gear")
                        .tag(PreferencesTab.general)
                    Label("PREFERENCES_TAB_ACTIVITIES".localizedWithEnglishFallback(), systemImage: "music.note")
                        .tag(PreferencesTab.activities)
                }

                Section {
                    Label("PREFERENCES_TAB_ABOUT".localizedWithEnglishFallback(), systemImage: "info.circle")
                        .tag(PreferencesTab.about)
                }
            }
            .frame(minWidth: EncoreApp.kWindowSidebarMinimumWidth)
        } detail: {
            ScrollView {
                Group {
                    switch state.selectedTab {
                        case .general: GeneralView().navigationTitle("PREFERENCES_TAB_GENERAL".localizedWithEnglishFallback())
                        case .activities: ActivitiesView(bridge: bridge).navigationTitle("PREFERENCES_TAB_ACTIVITIES".localizedWithEnglishFallback())
                        case .about: AboutView().navigationTitle("PREFERENCES_TAB_ABOUT".localizedWithEnglishFallback())
                    }
                }
                .padding(EncoreApp.kWindowInsetSmall)
            }
            .frame(minWidth: EncoreApp.kWindowMinimumWidth - EncoreApp.kWindowSidebarMinimumWidth, minHeight: EncoreApp.kWindowMinimumHeight)
        }
    }
}
