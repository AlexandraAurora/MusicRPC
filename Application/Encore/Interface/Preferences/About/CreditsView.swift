//
//  CreditsView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import SwiftUI

internal struct CreditsView: View {
    @Environment(\.dismiss) private var dismiss

    private let libraries: [CreditLinkView.Library] = [
        CreditLinkView.Library(
            name: "discord-rpc",
            url: "https://github.com/EinTim23/discord-rpc",
            license: "Apache License 2.0"
        ),
        CreditLinkView.Library(
            name: "Noto Sans",
            url: "https://fonts.google.com/noto/specimen/Noto+Sans",
            license: "SIL Open Font License 1.1"
        ),
        CreditLinkView.Library(
            name: "Noto Sans Mono",
            url: "https://fonts.google.com/noto/specimen/Noto+Sans+Mono",
            license: "SIL Open Font License 1.1"
        ),
        CreditLinkView.Library(
            name: "SPTPersistentCache",
            url: "https://github.com/spotify/SPTPersistentCache",
            license: "Apache License 2.0"
        ),
        CreditLinkView.Library(
            name: "UniversalGlass",
            url: "https://github.com/Aeastr/UniversalGlass",
            license: "MIT License"
        ),
        CreditLinkView.Library(
            name: "xxHash",
            url: "https://github.com/Cyan4973/xxHash",
            license: "BSD 2-Clause License"
        )
    ]

    internal var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("PREFERENCES_TAB_ABOUT_CREDITS".localizedWithEnglishFallback())
                .font(.title2)
                .fontWeight(.semibold)

            ScrollView {
                VStack(alignment: .leading, spacing: .zero) {
                    ForEach(self.libraries, id: \.name) { library in
                        CreditLinkView(library: library)
                    }
                }
            }
            .frame(maxHeight: 250)
            .padding(.vertical, EncoreApp.kItemSpacing)

            HStack(alignment: .center, spacing: .zero) {
                Spacer()
                Button("PREFERENCES_TAB_ABOUT_CREDITS_CLOSE".localizedWithEnglishFallback()) {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .frame(width: 300)
        .padding(32)
    }
}
