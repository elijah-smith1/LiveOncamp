////
////  evnetViewModel.swift
////  OnCampApp
////
////  Created by Michael Washington on 1/19/24.
////
//
//import Foundation
//@MainActor
//class eventViewModel: ObservableObject {
//    @Published var events: [Event] = []
//    private var eventData = EventData() // Assuming EventData contains the necessary methods
//
//    // Initializer
//    init() {
//        Task {
//            await fetchEvents()
//        }
//    }
//
//    // Asynchronously fetch events
//    private func fetchEvents() async {
//        do {
//            let eventIds = try await eventData.fetchEventIds()
//            var fetchedEvents: [Event] = []
//
//            for eventId in eventIds {
//                let event = try await eventData.getEventData(eventID: eventId)
//                fetchedEvents.append(event)
//            }
//
//            // Update the published events array
//            self.events = fetchedEvents
//
//        } catch {
//            // Handle any errors
//            print("Error fetching events: \(error.localizedDescription)")
//        }
//    }
//}
