//
//  AppState.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 2/12/24.
//

import Combine

class AppState: ObservableObject {
    @Published var selectedTab: Int = 0 // Default to the profile tab as per your current setup
}
