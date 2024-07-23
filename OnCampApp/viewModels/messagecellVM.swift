//
//  messagecellVM.swift
//  OnCampApp
//
//  Created by Elijah and Mike on 6/22/24.
//

import SwiftUI

class MessageCellViewModel: ObservableObject {
    //variables declaration
    @StateObject var messageData = MessageData()
    @Published var username: String = ""
    @StateObject var inboxviewModel = inboxViewModel()
    @Published var message: Message?
    @Published var content: String = ""
    @Published var Otherparticipant: String = ""
    @Published var pfpUrl: String = ""
    
    //
    func fetchRecentMessage(chatId: String){
        Task {
            do {
                let message = try await inboxviewModel.fetchMostRecentMessage(forChatId: chatId)
                self.message = message
                self.content = message!.content
            }
        }
    }
    func fetchRecentGroupMessage(channelId: String){
        Task {
            do {
                let message = try await inboxviewModel.fetchMostRecentGroupMessage(forChannelId: channelId)
                self.message = message
                self.content = message.content
             
            }
        }
    }
    func fetchName(patricipants: [String]){
        let other = inboxviewModel.otherParticipants(forParticipants: patricipants)
        self.Otherparticipant = other
    }
    func loadUsername(otherParticipantId: String) {
            Task {
                do {
                    let fetchedUser = try await messageData.fetchUserDocument(for: otherParticipantId)
                    DispatchQueue.main.async {
                        self.username = fetchedUser.username
                        self.pfpUrl = fetchedUser.pfpUrl
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
}
