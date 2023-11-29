import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        // Conditional view rendering based on login status
        if authViewModel.isLoggedIn {
            // User is logged in, show HomeView
            HomeView()
        } else {
            // User is not logged in, show RegistrationView
            RegistrationView()
        }
    }
}
