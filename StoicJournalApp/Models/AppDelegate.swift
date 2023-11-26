import SwiftUI
import Firebase

// Define AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // Configure Firebase here
    FirebaseApp.configure()
    return true
  }
  
  // Add any other AppDelegate methods as needed for Firebase functionality
}

@main
struct StoicJournalApp: App {
  // Register AppDelegate
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  @Environment(\.scenePhase) private var scenePhase

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .onChange(of: scenePhase) { phase in
      // Handle lifecycle changes
      switch phase {
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
