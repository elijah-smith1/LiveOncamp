//
//  PostModel.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 2/12/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Post: Codable, Hashable, Identifiable {  // Conform to Codable and Identifiable
    @DocumentID var id: String?  // Use DocumentID to automatically map the Firestore document ID
    var postText: String
    var postedBy: String
    var postedAt: Timestamp
    var likeCount: Int
    var repostCount: Int
    var commentCount: Int
    var username: String
    var mediaUrl: String?
    var pfpUrl: String?
    
    enum CodingKeys: String, CodingKey {  // Define coding keys if they differ from your property names
        case postText = "content"
        case postedBy = "postedBy"
        case postedAt
        case likeCount
        case repostCount
        case commentCount
        case username
        case mediaUrl
        case pfpUrl
    }
    
}
