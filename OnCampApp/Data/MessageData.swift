//
//  MessageData.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/17/23.
//

import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift


@MainActor
class MessageData: ObservableObject {
    
    enum ChatDataError: Error {
        case invalidChatData
        case chatNotFound
        case userNotFound
        // Add more error cases as needed
        
        var localizedDescription: String {
            switch self {
            case .invalidChatData:
                return "Invalid chat data."
            case .chatNotFound:
                return "Chat not found."
            case .userNotFound:
                return "User not found."
            // Add localized descriptions for other error cases
            }
        }
    }

    func fetchUserDocument(for userId: String) async throws -> (username: String, pfpUrl: String) {
        let userDocument = Userdb.document(userId)
        
        let documentSnapshot = try await userDocument.getDocument()
        
        guard let userDocumentData = documentSnapshot.data(),
              let username = userDocumentData["username"] as? String,
              let pfpUrl = userDocumentData["pfpUrl"] as? String else {
            throw NSError(domain: "UserDataService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User document not found or missing required data"])
        }
        
        return (username, pfpUrl)
    }
    // Assume you have a Firestore reference to your chats collection
    let chatsCollection = Firestore.firestore().collection("chats")

    

    
    
    
}
