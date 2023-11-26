//
//  SaveButtonView.swift
//  StoicJournalApp
//
//  Created by Rin Otori on 11/15/23.
//

import SwiftUI

struct SaveButtonView: View {
    @Binding var isLoading: Bool // Binding to control loading state
    var action: () -> Void // Action to be executed when the button is tapped

    var body: some View {
        // Display a "Save" button with specified attributes
        Button("Save", action: action)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(isLoading) // Disable the button when isLoading is true
            .accessibilityLabel("Save Journal Entry") // Accessibility label for the button
    }
}
