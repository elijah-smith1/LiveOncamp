import SwiftUI
import FirebaseFirestore

struct Chat: View {
  //  let user: User
    let chats: Chats
    @StateObject var viewmodel = ChatViewModel()
    @State private var messageText = ""
    @State private var messages: [Message] = []  // Assuming Message is your message model
    @State private var listenerRegistration: ListenerRegistration?  // State variable for the listener registration
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(messages, id: \.id) { message in
                        DetailedChatBubbles(isFromCurrentUser: message.senderId == loggedInUid, message: message)
                    }
                }
            }

            CustomChatInput(text: $messageText, action: {
                viewmodel.sendMessage(chatId: chats.id!, messageContent: messageText)
                messageText = ""  // Clear the input field after sending
            })
        }
        //.navigationBarTitle(user.username)
        .padding(.vertical)
        .onAppear {
            
            listenerRegistration = viewmodel.listenForMessages(forChat: chats.id!) { messages in
                       self.messages = messages
                   }
               }
               .onDisappear {
                   listenerRegistration?.remove()
               }
    }
}

// Update your PreviewProvider accordingly
//struct Chat_Previews: PreviewProvider {
//    static var previews: some View {
//        Chat(chatId: "chat")
//    }
//}
