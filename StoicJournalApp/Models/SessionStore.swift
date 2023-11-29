//
//  SessionStore.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/26/23.
//

import Foundation
import Combine
import FirebaseAuth

class SessionStore: ObservableObject {
    @Published var isLoggedIn: Bool = false

    func listenAuthenticationChanges() {
        // Listen to Firebase Auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.isLoggedIn = user != nil
        }
    }

    init() {
        listenAuthenticationChanges()
    }

    // Add other session-related methods here
}
