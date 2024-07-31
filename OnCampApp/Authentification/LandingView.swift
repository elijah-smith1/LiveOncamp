//
//  LandingView.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 7/30/24.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Text("Loading...")
        }
    }
}
