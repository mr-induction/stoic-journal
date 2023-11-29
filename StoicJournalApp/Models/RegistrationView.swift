import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    @State private var email = "" // State variable to hold the email input
    @State private var password = "" // State variable to hold the password input
    @State private var isUserAuthenticated = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email) // TextField for email input
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password) // SecureField for password input
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Register") {
                    registerUser(email: email, password: password) // Pass the email and password to the register function
                }
                
                NavigationLink(destination: HomeView(), isActive: $isUserAuthenticated) {
                    EmptyView()
                }
            }
        }
    }
    
    // Method to handle user registration
    private func registerUser(email: String, password: String) {
        print("Attempting to register user with email: \(email)")
        
        let authManager = AuthenticationManager()
        
        authManager.registerUser(email: email, password: password) { error in
            DispatchQueue.main.async { // Ensure UI updates are on the main thread
                if let error = error {
                    // Print the error if registration fails
                    print("Registration failed with error: \(error.localizedDescription)")
                } else {
                    // If there is no error, assume registration was successful
                    print("User registered successfully. Redirecting to HomeView...")
                    self.isUserAuthenticated = true
                }
            }
        }
    }
}
