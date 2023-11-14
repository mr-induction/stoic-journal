//
//  StoicJournalApp.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/12/23.
//


import SwiftUI
import Firebase

// Custom AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configure Firebase here if needed
        FirebaseApp.configure()
        return true
    }

    // Implement other delegate methods as needed
}

@main
struct YourApp: App {
    // Use AppDelegate with UIApplicationDelegateAdaptor
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            CombinedView()
        }
    }
}
