import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChannelFeed: View {
    
    @StateObject var viewmodel = ChatViewModel()
    @State private var messageText = ""
    @State private var messages: [Message] = []  // Assuming Message is your message model
    @State private var listenerRegistration: ListenerRegistration?
    @State private var showingInfoView = false
    
    let channel: Channel
    
    var body: some View {
        VStack {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(messages, id: \.id) { message in
                        DetailedChatBubbles(isFromCurrentUser: message.senderId == Auth.auth().currentUser?.uid, message: message)
                    }
                }
            }.onAppear{
                listenForMessages()
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
                ChannelInfo(channel: channel)
            }
    }
    func listenForMessages() {
        listenerRegistration = viewmodel.listenForChannelMessages(forChannel: channel.id!){ newMessages in
            self.messages = newMessages
        }
    }
}
