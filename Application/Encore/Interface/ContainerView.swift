//
//  ContainerView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import SwiftUI

internal protocol BodyView: View {
    associatedtype ContentBody: View

    var navigationTitle: String { get }
    @ViewBuilder var content: ContentBody { get }
}

extension BodyView {
    var body: some View {
        ScrollView {
            content
                .padding(UI.kWindowInsetSmall)
        }
        .navigationTitle(self.navigationTitle)
    }
}
