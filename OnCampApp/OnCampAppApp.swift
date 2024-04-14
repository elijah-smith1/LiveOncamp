//
//  OnCampAppApp.swift
//  OnCampApp
//
//  Created by Michael Washington on 10/8/23.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseInAppMessaging
import FirebaseMessaging
import UserNotifications
import Foundation


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        // Set Firebase Messaging delegate
        Messaging.messaging().delegate = self
        // Set up user notifications
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()


        return true
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
      UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        
        
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS Token received")
        // Set the APNS token in Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken

        // Immediately fetch the FCM token
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                // Handle the retrieved token as needed
            }
        }
    }

    // Add other necessary delegate methods if needed
    
}

// The rest of your SwiftUI App structure remains unchanged
@main
struct OnCampAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var userData = UserData()
    var appstate = AppState()
    
    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser?.uid != nil {
                /*Signoutbutton*/
                tabBar()
                    .environmentObject(UserData())
                    .environmentObject(AppState())
                // Use the existing userData
            } else {
                Landing()
            }
        }
    }
}
