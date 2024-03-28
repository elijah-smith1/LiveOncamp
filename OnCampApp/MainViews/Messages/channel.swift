import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChannelFeed: View {
//    var channelId: String
    @StateObject var viewmodel = ChatViewModel()
    @State private var messageText = ""
    @State private var messages: [Message] = []  // Assuming Message is your message model
    @State private var listenerRegistration: ListenerRegistration?
    @State private var showingInfoView = false
//    let channelId: String
    let channel: Channel
//    @State var imageUrl: String = ""
    var body: some View {
        VStack {
            ScrollView {
                
//                VStack(alignment: .leading, spacing: 12) {
//                    ForEach(messages, id: \.id) { message in
//                        DetailedChatBubbles(isFromCurrentUser: message.senderId == Auth.auth().currentUser?.uid, message: message)
//                    }
//                }
            }
            .padding(.horizontal)
            
            CustomChatInput(text: $messageText, action: {
                viewmodel.sendChannelMessage(channelId: channel.id!, messageContent: messageText, imageUrl: nil)
            })
        }.navigationTitle(channel.title)
        .padding(.vertical)
        .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showingInfoView = true
                            }) {
                                Image(systemName: "info.circle")
                            }
                        }
                    }
                    .sheet(isPresented: $showingInfoView) {
                        // Your Info View Here
                        ChannelInfo(channel: channel)
                    }
        
    }
    
    func sendMessage() {
        guard !messageText.isEmpty else { return }
        // Assuming `sendMessage` in `ChatViewModel` takes the channel ID, message content, and potentially the sender ID
        
        messageText = ""  // Clear the input field after sending
    }
    
    func listenForMessages() {
        // Assuming `listenForMessages` returns a ListenerRegistration that you can use to remove the listener later
//        listenerRegistration = viewmodel.listenForMessages(forChat: channelId) { newMessages in
//            self.messages = newMessages
//        }
    }
}

// Assume CustomChatInput and DetailedChatBubbles are defined elsewhere
