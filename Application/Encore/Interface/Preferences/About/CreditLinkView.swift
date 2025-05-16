//
//  CreditLinkView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import SwiftUI

internal struct CreditLinkView: View {
    internal struct Library {
        let name: String
        let url: String
        let license: String
    }

    internal let library: Library

    internal var body: some View {
        Link(destination: URL(string: self.library.url)!) {
            HStack(alignment: .center, spacing: .zero) {
                VStack(alignment: .leading, spacing: .zero) {
                    Text(self.library.name)
                        .fontWeight(.medium)

                    Text(self.library.license)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
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
            .padding(.vertical, 4)
    }
}
