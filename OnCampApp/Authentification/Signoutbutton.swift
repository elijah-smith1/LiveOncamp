import SwiftUI
import Firebase

struct Signoutbutton: View {
    @State var isSignedOut = false

    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: Landing(), isActive: $isSignedOut) {
                    EmptyView()
                }
                Button("Signout") {
                    signOut()
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            print("Signout successful")
            // Successful sign-out
            isSignedOut = true
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
}

struct Signoutbutton_Previews: PreviewProvider {
    static var previews: some View {
        Signoutbutton()
    }
}
