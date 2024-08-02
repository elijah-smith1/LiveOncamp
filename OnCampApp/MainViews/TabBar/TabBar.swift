import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseMessaging

struct tabBar: View {
    @Binding var path: NavigationPath // Add NavigationPath binding
    @StateObject var Tabviewmodel = tabViewModel()
    @StateObject var messages = inboxViewModel()
    @State private var selectedTab = 0 // Local state for selected tab

    var body: some View {
        Group {
            if Tabviewmodel.isLoading {
                LoadingView()
            } else if let errorMessage = Tabviewmodel.errorMessage {
                VStack {
                    Text("Error: \(errorMessage)")
                    Button(action: {
                        do {
                            try Auth.auth().signOut()
                            selectedTab = 0 // Reset the selected tab
                        } catch {
                            print("Failed to sign out: \(error)")
                        }
                    }) {
                        Text("Sign Out")
                    }
                }
            } else if let user = Tabviewmodel.userData.currentUser {
                TabView(selection: $selectedTab) {
                    Feed()
                        .tabItem {
                            Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        }
                        .tag(0)
                    
                    Social()
                        .tabItem {
                            Image(systemName: selectedTab == 1 ? "person.3.fill" : "person.3")
                        }
                        .tag(1)
                    
                    Marketplace(user: user)
                        .tabItem {
                            Image(systemName: selectedTab == 2 ? "bag.fill" : "bag")
                        }
                        .tag(2)
                    
                    CreatePost(user: user)
                        .tabItem {
                            Image(systemName: selectedTab == 3 ? "plus.bubble.fill" : "plus.bubble")
                        }
                        .tag(3)
                    
                    Profile(user: user)
                        .tabItem {
                            Image(systemName: selectedTab == 4 ? "person.circle.fill" : "person.circle")
                        }
                        .tag(4)
                }
                .navigationBarBackButtonHidden()
            }
        }
    }
}

struct tabBar_Previews: PreviewProvider {
    static var previews: some View {
        tabBar(path: .constant(NavigationPath()))
            .environmentObject(UserData())
    }
}
