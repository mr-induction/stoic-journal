import SwiftUI
import FirebaseAuth


struct RegistrationView: View {
    @StateObject private var authManager = AuthenticationManager()
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var showingLogin = false
    
    var body: some View {
        VStack {
            if showingLogin {
                LoginView() // Assuming LoginView is another struct conforming to View
            } else {
                registrationForm
            }
        }
    }
    
    private var registrationForm: some View {
        Group {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            errorMessageView
            
            registerButton
        }
    }
    
    private var errorMessageView: some View {
        Group {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var registerButton: some View {
        Button("Register") {
            registerUser()
        }
        .padding()
    }
    
    private func registerUser() {
        authManager.registerUser(email: email, password: password) { error in
            errorMessage = error?.localizedDescription
        }
    }
}

