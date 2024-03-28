//
//  EventModel.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 2/12/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var host: String
    var location: String
    var participants: Int
    var ticketLinks: [String]
    var imageUrls: [String]?
    var features: [String]
    // Add other relevant properties here
}
