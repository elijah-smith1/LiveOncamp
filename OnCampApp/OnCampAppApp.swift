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


@main
struct OnCampAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var userData = UserData()
    @StateObject var appstate = AppState()
    @State private var path = NavigationPath() // Initialize the navigation path

    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser?.uid != nil {
                tabBar(path: $path)
                    .environmentObject(userData)
                    .environmentObject(appstate)
            } else {
                Landing(path: $path) // Pass the navigation path to Landing view
                    .environmentObject(userData)
                    .environmentObject(appstate)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    // Function to check if a user is logged in
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    // This function is called when a remote notification is received
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if isUserLoggedIn() {
            // Process the message since the user is logged in
            handleRemoteNotification(userInfo)
        } else {
            // Ignore the message since no user is logged in
            print("No user is logged in. Ignoring message.")
        }
        completionHandler(.newData)
    }

    // Add your existing handleRemoteNotification function or logic here
    func handleRemoteNotification(_ userInfo: [AnyHashable: Any]) {
        // Your existing message handling logic
        print("Message received: \(userInfo)")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        // Register for remote notifications
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        application.registerForRemoteNotifications()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")

        // Send the token to Firebase
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }

    // MARK: UNUserNotificationCenterDelegate

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if isUserLoggedIn() {
            // Handle foreground notification
            completionHandler([.alert, .badge, .sound])
        } else {
            print("No user is logged in. Ignoring foreground notification.")
            completionHandler([])
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if isUserLoggedIn() {
            // Handle notification response
            let userInfo = response.notification.request.content.userInfo
            handleRemoteNotification(userInfo)
        } else {
            print("No user is logged in. Ignoring notification response.")
        }
        completionHandler()
    }

    // Add other necessary AppDelegate methods here
}
