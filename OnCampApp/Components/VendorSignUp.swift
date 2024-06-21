//
//  VendorSignUp.swift
//  OnCampApp
//
//  Created by Michael Washington on 6/14/24.
//

import SwiftUI

struct VendorSignUp: View {
    @Binding var path: NavigationPath // Add NavigationPath binding

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    VendorSignUp(path: .constant(NavigationPath()))
}
