//
//  Events.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/28/23.
//

import SwiftUI

struct Events: View {
    let event: Event
    @ObservedObject var viewmodel = eventViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyHStack(spacing: 32) {
                    ForEach(viewmodel.events, id: \.id) { events in
                        NavigationStack{
                            EventPreview(event: event)
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

//#Preview {
//    Events()
//}

