//
//  ChannelModel.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 2/12/24.
//


import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
struct Channel: Identifiable, Codable {
    @DocumentID var id: String?
    var participants: [String]
    var senders: [String]
    var security: String
    var title: String
    var description: String
    var imageUrl: String    
}

