import Foundation
import FirebaseAuth

class AuthenticationManager: ObservableObject {
    @Published var isUserAuthenticated: Bool = false

    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            print("User state changed. User is \(user != nil ? "" : "not ")authenticated.")
            self?.isUserAuthenticated = (user != nil)
        }
    }


    // Method for login
    func loginUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                } else {
                    self.isUserAuthenticated = true
                    completion(nil)
                }
            }
        }
    }

    // Method for registration
    func registerUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                } else {
                    self?.isUserAuthenticated = true
                    completion(nil)
                }
            }
        }
    }
}

