import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var showingRegistration = false
    
    var body: some View {
        VStack {
            if showingRegistration {
                RegistrationView()
            } else {
                loginForm
            }
        }
        .padding()
    }
    
    private var loginForm: some View {
        Group {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            errorMessageView
            
            loginButton
            
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
    
    private var loginButton: some View {
        Button("Login") {
            loginUser()
        }
        .padding()
    }
    
    private var registerButton: some View {
        Button("Need an account? Register") {
            showingRegistration = true
        }
        .padding()
    }
    
    private func loginUser() {
        authManager.loginUser(email: email, password: password) { error in
            errorMessage = error?.localizedDescription
        }
    }
}
