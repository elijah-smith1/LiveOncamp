//
//  inboxViewModel.swift
//  OnCampApp
//
//  Created by Elijah Smith on 11/17/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore


@MainActor
class inboxViewModel: ObservableObject{
    @Published var channels: [Channel] = []
    @Published var chats: [Chats] = []
    init(){
        Task {
            do {
                let chats = try await fetchChats()
                self.chats = chats
                let channels = try await fetchChannels()
                self.channels = channels
                //For each that runs fetch messages to return a message with each chat
                //
            } catch {
                // Handle error
                print("Error fetching things: \(error)")
            }
            
        }
    }
    let db = Firestore.firestore()
    func fetchChats() async throws -> [Chats] {
       
        // Reference to the "Chats" collection, filtering to include only chats where the "participants" field contains the logged-in user's UID
        let channelRef = db.collection("Chats").whereField("participants", arrayContains: loggedInUid!)
        // Attempt to fetch the documents
        let querySnapshot = try await channelRef.getDocuments()
        // Map each document to a Chats object
        let chats = try querySnapshot.documents.compactMap { document -> Chats? in
            try document.data(as: Chats.self)
        }
        return chats
    }

    func fetchChannels() async throws -> [Channel] {
        let db = Firestore.firestore()
        // Reference to the "Channels" collection
        let channelRef = db.collection("Channels").whereField("participants", arrayContains: loggedInUid!)
        // Attempt to fetch the documents
        let querySnapshot = try await channelRef.getDocuments()
        // Map each document to a Channel object
        let channels = try querySnapshot.documents.compactMap { document -> Channel? in
            try document.data(as: Channel.self)
        }
        return channels
    }
        // Function to fetch the most recent message for each chatId
    func fetchMostRecentMessage(forChatId chatId: String) async throws -> Message? {
        let db = Firestore.firestore()
        let chatRef = db.collection("Chats").document(chatId)
        let messagesRef = chatRef.collection("recentMessages").document("recentMessages")

        do {
            let querySnapshot = try await messagesRef.getDocument()
            let message = try querySnapshot.data(as: Message.self)
            return message
        } catch {
            print("Error fetching recent message: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchMostRecentGroupMessage(forChannelId channelId: String) async throws -> Message {
        let db = Firestore.firestore()
        let chatRef = db.collection("Channels").document(channelId)
        let messagesRef = chatRef.collection("recentMessages").document("recentMessages")

        do {
            let querySnapshot = try await messagesRef.getDocument()
            let message = try querySnapshot.data(as: Message.self)
            return message
        } catch {
            print("Error fetching recent message: \(error.localizedDescription)")
            throw error
        }
    }
    func otherParticipants(forParticipants participants: [String]) -> String {
        // Filter the participants array to exclude the loggedinUid
        let otherParticipants = participants.filter { $0 != loggedInUid }
        
        // Join the remaining elements into a single string, if that's what's needed.
        // Adjust this part based on how you want to use the result.
        // For example, you could just return the array or handle the elements individually.
        let resultString = otherParticipants.joined(separator: ", ")
        
        return resultString
    }


}
