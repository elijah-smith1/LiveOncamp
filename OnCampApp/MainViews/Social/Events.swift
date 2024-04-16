//
//  Events.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/28/23.
//

import SwiftUI

struct Events: View {
   @ObservedObject var viewmodel = eventViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewmodel.events, id: \.id) { events in
                        NavigationStack{
                            EventPreview()
                                .frame(height: 400)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Divider()
                        }
                    }
                }
            }
            .navigationDestination(for: Int.self) { events in
            }
        }
    }
}

struct Events_Previews: PreviewProvider {
    static var previews: some View {
        Events()
    }
}
