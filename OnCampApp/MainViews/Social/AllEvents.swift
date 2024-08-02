//
//  AllEvents.swift
//  OnCampApp
//
//  Created by Michael Washington on 3/23/24.
//

import SwiftUI

struct AllEvents: View {
    let event: Event
    @ObservedObject var viewModel = eventViewModel() // Ensure this view model properly fetches and stores your events

    var body: some View {
        NavigationStack {
            EventPreview(event: event) // Assuming EventPreview handles all the grid setup and navigation internally
        }
    }
}


//#Preview {
//    AllEvents()
//}
