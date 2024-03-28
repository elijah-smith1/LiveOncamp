//
//  ChatModel.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 2/12/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Chats: Identifiable, Codable {
    @DocumentID var id: String?
    var participants: [String]
    var read: Bool?
}

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var senderId: String
    var content: String
    var timestamp: Date
    var read: Bool?
}

struct EventMessage: Identifiable, Codable {
    @DocumentID var id: String?
    var eventId: String
    var text: String
    var senderId: String
    var timestamp: Date
    
}

struct PostMessage: Identifiable, Codable {
    @DocumentID var id: String?
    var postId: String
    var text: String
    var senderId: String
    var timestamp: Date
    
}
