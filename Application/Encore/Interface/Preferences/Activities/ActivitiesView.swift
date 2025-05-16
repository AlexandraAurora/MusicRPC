//
//  ActivitiesSettingsTab.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

internal struct ActivitiesView: View {
    internal var bridge: EncoreCoreBridge

    internal var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            GroupContainer {
                ActivityPreview(bridge: bridge)
            }
            Text("PREFERENCES_TAB_ACTIVITIES_PREVIEW_DESCRIPTION".localizedWithEnglishFallback(Bundle.main.bundleName))
                .preferencesDescriptionStyle()
                .padding(.bottom, EncoreApp.kItemSpacing)

            GroupContainer {
            }
        }
    }
}
