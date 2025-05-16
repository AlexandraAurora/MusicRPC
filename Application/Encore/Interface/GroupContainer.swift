//
//  GroupContainer.swift.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import SwiftUI

internal struct GroupContainer<Content: View>: View {
    @ViewBuilder internal let content: Content

    internal var body: some View {
        content
            .padding(EncoreApp.kItemSpacing)
            .background(RoundedRectangle(cornerRadius: 12).fill(.quinary))
    }
}
