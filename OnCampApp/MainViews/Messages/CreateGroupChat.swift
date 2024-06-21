//
//  CreateGroupChat.swift
//  OnCampApp
//
//  Created by Elijah Smith on 1/8/24.
//

import SwiftUI

struct CreateGroupChat: View {
    @StateObject var viewmodel = NewMessageViewModel()
    @State private var selectedUsers: [User] = []
    @State private var newChat: Chats?
    @State private var navigateToChat = false
    @State private var searchText = ""
    @State private var newChannel: Channel?
    @State private var navigateToChannel = false
    var filteredUsers: [User] 
    {
        if searchText.isEmpty {
            return viewmodel.users
        } else {
            return viewmodel.users.filter { $0.username.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {

        NavigationStack {
            ScrollView {
                // Display selected users
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Text("To:").font(.headline)
                        ForEach(selectedUsers, id: \.username) { user in
                            Text(user.username)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(Capsule().fill(Color.blue))
                                .foregroundColor(.white)
                                .onTapGesture {
                                    selectUser(user: user) // Allow deselection by tapping
                                }
                        }
                    }
                    .padding()
                }
                VStack(spacing: 0) {
                    ForEach(filteredUsers, id: \.username) { user in
                        UserChannelCell(user: user).onTapGesture {
                            selectUser(user: user)
                        }
                        Divider()
                    }
                }
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                        Button("Create Chat") {
                            Task{
                                do{
                                    await createChatWithSelectedUsers()
                                }
                            }
                        }
                        .disabled(selectedUsers.isEmpty) // Disable the button if no users are selected
                    }
                
            }
            .navigationDestination(isPresented: $navigateToChannel) {
                ChannelFeed(channel: newChannel ?? Channel(participants: [], senders: [], security: "", title: "String", description: "String", imageUrl: ""))
            }
            .navigationDestination(isPresented: $navigateToChat) {
                Chat(chats: newChat ?? Chats(participants: []))
            }
        .padding()
        }
        .searchable(text: $searchText, prompt: "Search Users")
        .onSubmit(of: .search, {
            // Handle search submission if needed
        })
    }
    
    func selectUser(user: User) {
        if selectedUsers.contains(where: { $0.username == user.username }) {
            selectedUsers.removeAll { $0.username == user.username }
        } else {
            selectedUsers.append(user)
        }
    }
    
    func createChatWithSelectedUsers() async {
        if selectedUsers.count == 1 {
            // Assuming only one user is selected, we're creating or retrieving a direct chat
            do {
                
                let chat = try await viewmodel.createOrRetrieveChatDocument(for: selectedUsers.first!)
                self.newChat = chat
                self.navigateToChat = true
                self.selectedUsers = []
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
                self.selectedUsers = []
            } catch {
                // Handle any errors, e.g., show an alert to the user
                print("Error creating group chat: \(error)")
            }
        }
    }

}

// Assume UserChannelCell, NewMessageViewModel, and User are defined elsewhere

#Preview {
    CreateGroupChat()
}
