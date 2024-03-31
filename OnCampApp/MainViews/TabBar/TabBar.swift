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
                
                if Tabviewmodel.userData.currentUser == nil {
                    Tabviewmodel.fetchCurrentUserIfNeeded()
                }

            }
            .navigationBarBackButtonHidden()
        } else {
            CreateAccount(uid: Auth.auth().currentUser!.uid)
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
