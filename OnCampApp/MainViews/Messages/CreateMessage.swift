//
//  CreateMessage.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/17/23.
//

import SwiftUI

struct CreateMessage: View {
    @StateObject var viewmodel = NewMessageViewModel()
    @State private var newChannel: Channel?
    @State private var navigateToChannel = false
    @State private var newChat: Chats?
    @State private var navigateToChat = false
    @Binding var showChatView: Bool
    @State private var selectedUsers: [User] = []
    @Environment(\.presentationMode) var mode
    @State private var searchText = ""
/* add in groupchat functionality to this code*/
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return viewmodel.users
        } else {
            return viewmodel.users.filter { $0.username.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(filteredUsers, id: \.username) { user in
                        UserChatCell(user: user).onTapGesture {
                            selectUser(user: user)
                        }
                        Divider()
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Create Chat") {
                            Task{
                                do{
                                    await createChat(selectedUsers: selectedUsers)
                                }
                            }
                        }
                        .disabled(selectedUsers.isEmpty) // Disable the button if no users are selected
                    }
            }
            .navigationTitle("New Message")
            .padding()
            // Button for creating a group chat
        }
        .searchable(text: $searchText, prompt: "Search Users")
        .onSubmit(of: .search, {
            // Handle search submission if needed
        })
        NavigationLink(destination: ChannelFeed( channel: newChannel ?? Channel(participants: [], senders: [], security: "", title: "String", description: "String", imageUrl: "")), isActive: $navigateToChannel) {
                EmptyView()
           }
        NavigationLink(destination: Chat(chats: newChat ?? Chats( participants: [])), isActive: $navigateToChat){
            EmptyView()
        }
        
    }

    private func createChat(selectedUsers: [User]) async {
        if selectedUsers.count == 1 {
            // Assuming only one user is selected, we're creating or retrieving a direct chat
            do {
                let chat = try await viewmodel.createOrRetrieveChatDocument(for: selectedUsers.first!)
                self.newChat = chat
                self.navigateToChat = true
            } catch {
                // Handle any errors, e.g., show an alert to the user
                print("Error creating or retrieving chat: \(error)")
            }
        } else if selectedUsers.count > 1 {
            // For multiple selected users, we're creating a group chat
            do {
                let channel = try await viewmodel.createGroupChat(for: selectedUsers)
                self.newChannel = channel
                self.navigateToChannel = true
            } catch {
                // Handle any errors, e.g., show an alert to the user
                print("Error creating group chat: \(error)")
            }
        }
    }

    func selectUser(user: User) {
        if selectedUsers.contains(where: { $0.id == user.id }) {
            selectedUsers.removeAll { $0.id == user.id }
        } else {
            selectedUsers.append(user)
        }
    }

}

struct CreateMessage_Previews: PreviewProvider {
    static var previews: some View {
        CreateMessage(showChatView: .constant(false))
    }
}
