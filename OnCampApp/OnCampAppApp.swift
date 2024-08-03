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

    var body: some Scene {
        WindowGroup {
            NavigationStack() {
                if Auth.auth().currentUser?.uid != nil {
                    tabBar()
                        .environmentObject(userData)
                        .environmentObject(appstate)
                        .onOpenURL { url in
                            if let deepLink = DeepLink(url: url) {
//                                path.append(deepLink)
                            }
                        }
                } else {
                    Landing() // Pass the navigation path to Landing view
                        .environmentObject(userData)
                        .environmentObject(appstate)
                        .onOpenURL { url in
                            if let deepLink = DeepLink(url: url) {
//                                path.append(deepLink)
                            }
                        }
                }
            }
        }
    }
}

enum DeepLink: Hashable {
    case messagesView

    init?(url: URL) {
        switch url.host {
        case "messages":
            self = .messagesView
        default:
            return nil
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

        if let deepLink = userInfo["custom_data"] as? [String: String], let urlString = deepLink["deep_link"], let url = URL(string: urlString) {
            // Open the deep link
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle the URL scheme
        if let scheme = url.scheme, scheme == "myapp" {
            // Extract and handle the deep link
            if let host = url.host {
                print("Deep link host: \(host)")
                // Navigate to the specific screen based on the host or path
                handleDeepLink(url: url)
            }
        }
        return true
    }

    func handleDeepLink(url: URL) {
        // Implement your navigation logic here
        print("Handling deep link: \(url)")
        // In SwiftUI, you might pass this URL to your SwiftUI views to handle navigation
        // For example, using a StateObject or EnvironmentObject
    }
}
