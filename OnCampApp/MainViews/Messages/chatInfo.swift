import SwiftUI

struct ChannelInfo: View {
    let channel: Channel // Assuming this is passed in and contains initial values
    @StateObject var viewmodel = ChatViewModel()
    
    // State variables to hold editable values and track changes
    @State private var editedTitle: String
    @State private var editedDescription: String
    
    // Initialize state variables with channel properties
    init(channel: Channel) {
        self.channel = channel
        _editedTitle = State(initialValue: channel.title)
        _editedDescription = State(initialValue: channel.description)
    }
    
    // Check if the user has made any changes
    var hasChanges: Bool {
        editedTitle != channel.title || editedDescription != channel.description
    }
    
    var body: some View {
        NavigationStack{
            List {
                Section(header: Text("Channel Info")) {
                    HStack {
                        Text("Title:")
                            .bold()
                        Spacer()
                        TextField("Title", text: $editedTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    HStack {
                        Text("Description:")
                            .bold()
                        Spacer()
                        TextField("Description", text: $editedDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    HStack {
                        Text("Participants:")
                            .bold()
                        Spacer()
                        Text("\(channel.participants.count)")
                    }
                }
            }
            .navigationTitle("Channel Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Save button only enabled if changes have been made
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Call your viewmodel update function here
                        viewmodel.updateChannelInfo(channelId: channel.id!, newTitle: editedTitle, newDescription: editedDescription) { error in
                            if let error = error {
                                // Handle error
                                print("Update failed: \(error.localizedDescription)")
                            } else {
                                // Success handling, e.g., show confirmation or dismiss view
                                print("Channel successfully updated")
                            }
                        }
                    }
                    .disabled(!hasChanges) // Disable if no changes
                }
            }
        }
    }
}
