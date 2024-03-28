//
//  MessageCell.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/17/23.
//

import SwiftUI


class MessageCellViewModel: ObservableObject {
    @ObservedObject var messageData = MessageData()
    @Published var username: String = ""
    @StateObject var inboxviewModel = inboxViewModel()
    @Published var message: Message?
    @Published var content: String = ""
    func fetchRecentMessage(chatId: String){
        Task {
            do {
                let message = try await inboxviewModel.fetchMostRecentMessage(forChatId: chatId)
                self.message = message
                self.content = message!.content
            }
        }
    }
    func loadUsername(otherParticipantId: String) {
        Task {
            do {
                let fetchedUsername = try await messageData.fetchUsername(for: otherParticipantId)
                DispatchQueue.main.async {
                    self.username = fetchedUsername
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct MessageCell: View {
    @ObservedObject var viewModel = MessageCellViewModel()
    let chats: Chats
    var body: some View {
        NavigationLink(destination: Chat(chats:chats)){
            VStack {
                HStack {
                    CircularProfilePictureView()
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("username/chatname here" )
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        Text(viewModel.content.isEmpty ?? true ? "didn't work" : viewModel.content ?? "didn't work")
                            .font(.system(size: 15))
                    }
                    .foregroundColor(Color("LTBL"))
                    
                    Spacer()
                }
                .padding(.horizontal)
                .onAppear {
                    viewModel.fetchRecentMessage(chatId: chats.id!) 
                }
                
                Divider()
            }
            .padding(.top)
        }
    }
}


//struct MessageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageCell()
//    }
//}
