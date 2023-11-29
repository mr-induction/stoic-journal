import Foundation
import FirebaseAuth
import FirebaseFirestore

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
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Registration error: \(error.localizedDescription)") // Debug: Print the error message
                    completion(error)
                } else if let uid = authResult?.user.uid {
                    // The user is successfully registered, now we need to store the user data in Firestore
                    self?.storeUserData(uid: uid, email: email, completion: completion)
                }
            }
        }
    }
    
    // Method to store user data in Firestore
    func storeUserData(uid: String, email: String, completion: @escaping (Error?) -> Void) {
        // Here we set up the Firestore document with the UID as the document ID
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData(["email": email]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Firestore error: \(error.localizedDescription)") // Debug: Print the error message
                    completion(error)
                } else {
                    print("User data stored in Firestore successfully!")
                    self.isUserAuthenticated = true // Fixed the reference to self here
                    completion(nil)
                }
            }
        }
    }
                }
   
