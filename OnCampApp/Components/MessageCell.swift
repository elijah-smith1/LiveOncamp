import SwiftUI

struct MessageCell: View {
    @ObservedObject var viewModel: MessageCellViewModel
    let chats: Chats
    
    init(chats: Chats) {
        self.chats = chats
        self.viewModel = MessageCellViewModel()
        viewModel.fetchRecentMessage(chatId: chats.id!)
        viewModel.fetchName(patricipants: chats.participants)
        viewModel.loadUsername(otherParticipantId: viewModel.Otherparticipant)
    }
    
    var body: some View {
        NavigationLink(destination: Chat(chats:chats)){
            VStack {
                HStack {
                    CircularProfilePictureView(profilePictureURL: viewModel.pfpUrl)
                        .frame(width: 40, height: 40)
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(viewModel.username.isEmpty ? "didn't work" : viewModel.username )
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        Text(viewModel.content.isEmpty ? "didn't work" : viewModel.content )
                            .font(.system(size: 15))
                    }
                    .foregroundColor(Color("LTBL"))
                    Spacer()
                }
                .padding(.horizontal)
                
                Divider()
            }
            .padding(.top)
        }
    }
}
