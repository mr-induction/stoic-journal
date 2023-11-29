//
//  AuthViewModel.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/27/23.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        isLoggedIn = Auth.auth().currentUser != nil
        setupAuthListener()
    }

    private func setupAuthListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isLoggedIn = user != nil
        }
    }
}
