//
//  ChatViewModel.swift
//  OnCampApp
//
//  Created by Elijah Smith on 11/13/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatViewModel: ObservableObject {
    
    func sendChannelMessage(channelId: String, messageContent: String, imageUrl: String?) {
        let db = Firestore.firestore()
        let senderId = Auth.auth().currentUser!.uid

        // Start with mandatory message data
        var messageData: [String: Any] = [
            "senderId": senderId,
            "content": messageContent,
            "timestamp": Timestamp(date: Date()),
            "read": false
        ]
        // Add imageUrl to messageData if it's not nil
        if let validImageUrl = imageUrl {
            messageData["imageUrl"] = validImageUrl
        }
        // Reference to the chat document
        let chatRef = db.collection("Channels").document(channelId)
        let recentMessage = db.collection("Channels").document(channelId).collection("recentMessages").document("recentMessages")
        // Add the message data to the messages subcollection of the chat
        chatRef.collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                print("Message sent successfully: \(messageData)")
            }
        }
        recentMessage.setData(messageData) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                print("Message sent successfully\(messageData)")
            }
        }

    }

    
    func sendMessage(chatId: String, messageContent: String) {
        let db = Firestore.firestore()
        let senderId = Auth.auth().currentUser!.uid
        
        // Define a dictionary to represent the message data
        let messageData: [String: Any] = [
            "senderId": senderId, // Use the current user's UID
            "content": messageContent, // Use the messageContent parameter
            "timestamp": Timestamp(date: Date()), // Use the current date and time
            "read": false // Initially, the message is not read

        ]
        
        // Reference to the chat document
        let chatRef = db.collection("Chats").document(chatId)
        let recentMessage = db.collection("Chats").document(chatId).collection("recentMessages").document("recentMessages")
        // Add the message data to the messages subcollection of the chat
        chatRef.collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                print("Message sent successfully\(messageData)")
            }
        }
        recentMessage.setData(messageData) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                print("Message sent successfully\(messageData)")
            }
        }
    }
    func listenForChannelMessages(forChannel channelId: String, completion: @escaping ([Message]) -> Void) -> ListenerRegistration{
        let db = Firestore.firestore()
        let messagesRef = db.collection("Channels").document(channelId).collection("messages")

        let listener = messagesRef
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error listening for message updates: \(error?.localizedDescription ?? "No error")")
                    return
                }

                let messages = snapshot.documents.compactMap { document -> Message? in
                    do {
                        return try document.data(as: Message.self)
                    } catch {
                        print("Error decoding message: \(error)")
                        return nil
                    }
                }
                completion(messages)
            }

        return listener
    }
    
    func listenForMessages(forChat chatId: String, completion: @escaping ([Message]) -> Void) -> ListenerRegistration {
        let db = Firestore.firestore()
        let messagesRef = db.collection("Chats").document(chatId).collection("messages")

        let listener = messagesRef
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error listening for message updates: \(error?.localizedDescription ?? "No error")")
                    return
                }

                let messages = snapshot.documents.compactMap { document -> Message? in
                    do {
                        return try document.data(as: Message.self)
                    } catch {
                        print("Error decoding message: \(error)")
                        return nil
                    }
                }
                completion(messages)
            }

        return listener
    }
    
    func updateChannelInfo(channelId: String, newTitle: String? = nil, newDescription: String? = nil, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        // Reference to the specific channel document in the "Channels" collection
        let channelRef = db.collection("Channels").document(channelId)
        
        // Initialize an empty dictionary to hold any fields to update
        var updateData: [String: Any] = [:]
        
        // Add fields to the dictionary only if they are not nil
        if let newTitle = newTitle {
            updateData["title"] = newTitle
        }
        
        if let newDescription = newDescription {
            updateData["description"] = newDescription
        }
        
        // Check if there's anything to update
        guard !updateData.isEmpty else {
            completion(nil) // No updates to perform
            return
        }
        
        // Update the document with the fields provided
        channelRef.updateData(updateData) { error in
            if let error = error {
                // Handle any errors
                completion(error)
            } else {
                // Update was successful
                completion(nil)
            }
        }
    }
}
