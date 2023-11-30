import SwiftUI
import Firebase

// Define AppDelegate
class AppDelegate: UIResponder, UIApplicationDelegate {
    // AppDelegate must inherit from UIResponder and conform to UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Configure Firebase here
        FirebaseApp.configure()
        return true
    }
  
    // Add any other AppDelegate methods as needed for Firebase functionality
}

@main
struct StoicJournalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var session = SessionStore() // SessionStore instance
    @StateObject var authenticationManager = AuthenticationManager() // AuthenticationManager instance
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            if session.isLoggedIn {
               HomeView()
                    .environmentObject(authenticationManager) // Provide AuthenticationManager
            } else {
                RegistrationView()
                    .environmentObject(session)
                    .environmentObject(authenticationManager) // Provide AuthenticationManager
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            // Handle lifecycle changes
            switch newScenePhase {
            case .background:
                print("App moved to background")
            case .inactive:
                print("App is inactive")
            case .active:
                print("App is active")
            @unknown default:
                print("A new scene phase occurred.")
            }
        }
    }
}
