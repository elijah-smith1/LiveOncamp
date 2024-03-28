//
//  ComentModel.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 2/12/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Comment: Codable, Identifiable, Hashable {
    @DocumentID var id: String?  // Firestore document ID
    var commenterUid: String
    var text: String
    var timeSent: Timestamp
    var commentReposts: Int
    var commentLikes: Int
    var pfpUrl: String?
    var username: String?

    // Custom initializer is optional if you're decoding from Firestore directly
    init(id: String, commenterUid: String, text: String, timeSent: Timestamp, commentReposts: Int, commentLikes: Int) {
        self.id = id
        self.commenterUid = commenterUid
        self.text = text
        self.timeSent = timeSent
        self.commentReposts = commentReposts
        self.commentLikes = commentLikes
    }
}
