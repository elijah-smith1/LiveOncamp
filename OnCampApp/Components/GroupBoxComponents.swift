//
//  GroupBoxComponents.swift
//  OnCampApp
//
//  Created by Michael Washington on 6/30/24.
//

import SwiftUI

struct LightBlueGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .bold()
                .foregroundColor(.white)
            configuration.content
        }
        .padding()
        .background(Color.blue.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct BlueGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .bold()
                .foregroundColor(.white)
            configuration.content
        }
        .padding()
        .background(Color.blue.opacity(0.8), in: RoundedRectangle(cornerRadius: 12))
    }
}

extension GroupBoxStyle where Self == LightBlueGroupBoxStyle {
    static var lightBlue: LightBlueGroupBoxStyle { .init() }
}

extension GroupBoxStyle where Self == BlueGroupBoxStyle {
    static var blue: BlueGroupBoxStyle { .init() }
}
