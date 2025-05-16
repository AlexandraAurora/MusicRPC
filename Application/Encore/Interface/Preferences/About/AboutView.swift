//
//  AboutSettingsTab.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import SwiftUI

internal struct AboutView: View {
    @State private var isShowingCredits: Bool = false

    internal var body: some View {
        GroupContainer {
            VStack(alignment: .center, spacing: .zero) {
                if let appIcon = NSImage(named: NSImage.applicationIconName) {
                    Image(nsImage: appIcon)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .padding(.bottom, EncoreApp.kItemSpacing)
                }

                Text(Bundle.main.bundleName)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("PREFERENCES_TAB_ABOUT_VERSION".localizedWithEnglishFallback(Bundle.main.bundleVersion))
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.bottom, EncoreApp.kItemSpacing)

        GroupContainer {
            VStack(alignment: .leading, spacing: .zero) {
                Link(destination: URL(string: "https://getencore.app")!) {
                    HStack(alignment: .center, spacing: .zero) {
                        Label("PREFERENCES_TAB_ABOUT_WEBSITE".localizedWithEnglishFallback(), systemImage: "globe")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 11))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.vertical, EncoreApp.kItemSpacing)

                Link(destination: URL(string: "https://github.com/getencore/Encore")!) {
                    HStack(alignment: .center, spacing: .zero) {
                        VStack(alignment: .leading, spacing: .zero) {
                            Label("PREFERENCES_TAB_ABOUT_SOURCE_CODE".localizedWithEnglishFallback(), systemImage: "curlybraces")
                            Text("PREFERENCES_TAB_ABOUT_LICENSE".localizedWithEnglishFallback())
                                .preferencesDescriptionStyle()
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 11))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.vertical, EncoreApp.kItemSpacing)

                Link(destination: URL(string: "https://github.com/getencore/Encore/issues")!) {
                    HStack(alignment: .center, spacing: .zero) {
                        VStack(alignment: .leading, spacing: .zero) {
                            Label("PREFERENCES_TAB_ABOUT_REPORT_AN_ISSUE".localizedWithEnglishFallback(), systemImage: "exclamationmark.bubble")
                            Text("PREFERENCES_TAB_ABOUT_OR_REQUEST_A_FEATURE".localizedWithEnglishFallback())
                                .preferencesDescriptionStyle()
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 11))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.vertical, EncoreApp.kItemSpacing)

                Button {
                    isShowingCredits = true
                } label: {
                    HStack(alignment: .center, spacing: .zero) {
                        Label("PREFERENCES_TAB_ABOUT_CREDITS".localizedWithEnglishFallback(), systemImage: "doc.text")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 11))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $isShowingCredits) {
            CreditsView()
        }

        let currentYear: String = String(Calendar(identifier: .gregorian).component(.year, from: .now))
        Text("PREFERENCES_TAB_ABOUT_COPYRIGHT".localizedWithEnglishFallback(Bundle.main.bundleName, currentYear))
            .preferencesDescriptionStyle()
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
