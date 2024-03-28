//
//  tabBar.swift
//  letsgetrich
//
//  Created by Michael Washington on 9/13/23.
//


import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseMessaging




struct tabBar: View {
    


    
    
    @EnvironmentObject var appState: AppState
    @StateObject var Tabviewmodel = tabViewModel()
    @StateObject var messages = inboxViewModel()
    
    var body: some View {
        if let user = Tabviewmodel.userData.currentUser {
            TabView(selection: $appState.selectedTab) {
                Feed()
                    .tabItem {
                        Image(systemName: appState.selectedTab == 0 ? "house.fill" : "house")
                    }
                    .tag(0)
                
                Social()
                    .tabItem {
                        Image(systemName: appState.selectedTab == 1 ? "person.3.fill" : "person.3")
                    }
                    .tag(1)
                
                Marketplace(user: user)
                    .tabItem {
                        Image(systemName: appState.selectedTab == 2 ? "bag.fill" : "bag")
                    }
                    .tag(2)
                
                CreatePost(user: user)
                    .tabItem {
                        Image(systemName: appState.selectedTab == 3 ? "plus.bubble.fill" : "plus.bubble")
                    }
                    .tag(3)
                
                Profile(user: user)
                    .tabItem {
                        Image(systemName: appState.selectedTab == 4 ? "person.circle.fill" : "person.circle")
                    }
                    .tag(4)
            }
            .onAppear {
                saveFCMToken()
                if Tabviewmodel.userData.currentUser == nil {
                    Tabviewmodel.fetchCurrentUserIfNeeded()
                }
                Messaging.messaging().subscribe(toTopic: "onCamp") { error in
                  if let error = error {
                    print("Error subscribing to topic: \(error.localizedDescription)")
                  } else {
                    print("Subscribed to news topic")
                  }
                }
            }
            .navigationBarBackButtonHidden()
        } else {
            CreateAccount(uid: Auth.auth().currentUser!.uid)
        }
    }
}

func saveFCMToken() {
    // Retrieve the FCM token from UserDefaults
    let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
    
    // Reference to the user's document in Firestore
    let userRef = Firestore.firestore().collection("Users").document(loggedInUid!)

    // Add the token to the document using updateData for a specific field update
    userRef.updateData(["FcmToken": fcmToken]) { error in
        if let error = error {
            // Handle any errors that occur during update
            print("Error updating document: \(error.localizedDescription)")
        } else {
            // Print a confirmation that the update was successful
            print("FCM token successfully updated for user")
        }
    }
}

//struct tabBar_Previews: PreviewProvider {
//
//    static var previews: some View {
//        tabBar()
//            .environmentObject(UserData())
//
//    }
//}
